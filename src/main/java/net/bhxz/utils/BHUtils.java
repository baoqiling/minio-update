package net.bhxz.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.minio.BucketExistsArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import io.minio.SetBucketPolicyArgs;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;
import java.io.*;
import java.util.HashMap;
import java.util.Map;

/***
 * @ClassName BHUtils
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/3/7 17:07 
 */
@Slf4j
public class BHUtils {

    public static boolean createFile(String fileName){
        File file = new File(fileName);
        boolean flag = false;
        if (!file.exists()) {
            try {
                file.createNewFile();
                flag = true;
            } catch (IOException e) {
                log.error("创建文件"+ fileName +"失败：" + e.getMessage());
                throw new RuntimeException(e);
            }
        }
        return flag;
    }

    public static boolean writeFile(String fileName, String message, boolean append) {
        if (fileName != null && !fileName.isEmpty()) {
            try (FileWriter fileWriter = new FileWriter(fileName, append); // true表示追加内容，false表示覆盖原有内容
                 BufferedWriter bufferedWriter = new BufferedWriter(fileWriter)
            ){
                bufferedWriter.write(message);
                return true;
            } catch (Exception var5) {
                log.error(var5.getMessage(), var5);
                return false;
            }
        } else {
            return false;
        }
    }
    public static String readFile(String fileName) {
        StringBuilder contentBuilder = new StringBuilder();
        BufferedReader reader = null;

        try {
            reader = new BufferedReader(new FileReader(fileName));
            String line;
            while ((line = reader.readLine()) != null) {
                contentBuilder.append(line).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
            // 可以选择抛出异常，或者返回null，或者返回一个错误消息等
            return null;
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return contentBuilder.toString();
    }

    public static String incrementVersion(String version) {
        version = String.join("", version).replaceAll("\\r|\\n", "");
        String[] parts = version.split("\\.");
        int lastPart = Integer.parseInt(parts[parts.length - 1]);
        lastPart++;
        parts[parts.length - 1] = String.valueOf(lastPart);
        return String.join(".", parts);
    }


    public static String pushWebhookBotNotify(RestTemplate restTemplate, String webhookUrl, String message){
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        Map<String, Object> jsonMap = new HashMap<>();
        Map<String, String> textMap = new HashMap<>();
        textMap.put("content", message);
        jsonMap.put("msgtype", "text");
        jsonMap.put("text", textMap);
        Gson gson = new GsonBuilder().create();

        String messageContent = gson.toJson(jsonMap);
        HttpEntity<String> entity = new HttpEntity<>(messageContent, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(webhookUrl, entity, String.class);
        return response.toString();

    }

    public static void bucketExistsAndCreate(String bucketName, MinioClient minioClient) throws Exception{
        BucketExistsArgs build = BucketExistsArgs.builder()
                .bucket(bucketName)
                .build();
        boolean isExist  = minioClient.bucketExists(build);
        if (!isExist) {
            MakeBucketArgs makeBucketArgs = MakeBucketArgs.builder().bucket(bucketName).build();
            minioClient.makeBucket(makeBucketArgs);
        }
    }
}
