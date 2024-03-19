package net.bhxz.controller;

import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.RemoveObjectArgs;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import net.bhxz.utils.BHUtils;
import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import java.io.*;
import java.util.Properties;


/***
 * @ClassName MinioController
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/3/7 9:50 
 */
@Slf4j
@Controller
@RequestMapping(value = "/minio", produces = MediaType.APPLICATION_JSON_VALUE)
@Api(value = "安装包上传minio接口", tags = "安装包上传minio接口", produces = MediaType.APPLICATION_JSON_VALUE)
public class MinioController {

    private final MinioClient minioClient;
    private final RestTemplate restTemplate;
    private final String webhookUrlCenter7 = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=608922c8-5e7c-4199-9b5e-f7e274ac8c3e";
            // "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=608922c8-5e7c-4199-9b5e-f7e274ac8c3e";

//            "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=d5c520d6-89fd-464e-830a-17e3dd212662";

    private final String propertiesCenter7 ="center7.properties";

    private final String propertiesCenter6 ="center6.properties";

    private final String propertiesSubway ="subway.properties";

    @Autowired
    public MinioController(MinioClient minioClient, RestTemplate restTemplate) {
        this.minioClient = minioClient;
        this.restTemplate = restTemplate;
    }


    @PostMapping("/center7/uploadFile")
    @ApiOperation(value = "7.0安装包上传接口")
    public ResponseEntity<String> uploadFile() {
        String fileUrl = "D:\\package\\center7\\BSServerSetup.exe";
        String folder = "7.0.3.0";
        BHUtils.createFile(propertiesCenter7);
        String propertiesStr = BHUtils.readFile(propertiesCenter7);
        Properties properties = new Properties();
        InputStream input = null;
        OutputStream output = null;
        try {
            if (StringUtils.isNotBlank(propertiesStr)){
                input = new FileInputStream(propertiesCenter7);
                properties.load(input);
                fileUrl = properties.getProperty("fileUrl");
                folder = properties.getProperty("version");
                String newVersion = BHUtils.incrementVersion(folder);
                properties.setProperty("version", newVersion);
                output = new FileOutputStream(propertiesCenter7);
                properties.store(output,"update version");
            }else {
                properties.setProperty("fileUrl","D:\\package\\center7\\BSServerSetup.exe");
                properties.setProperty("version", "7.0.3.0");
                output = new FileOutputStream(propertiesCenter7);
                properties.store(output, "init properties");
            }
        } catch (IOException e) {
            log.error("未读取到配置文件信息：" + e.getMessage());
            throw new RuntimeException(e);
        }finally {
            try {
                output.close();
                input.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        File file = new File(fileUrl);
        try (
                InputStream inputStream = new FileInputStream(file)
        ) {
            Tika tika = new Tika();
            String contentType = tika.detect(file);
            // 设置存储桶名称
            String bucketName = "package";

//            BHUtils.bucketExistsAndCreate(bucketName, minioClient);

            String name = "center7/" + folder + "/" + file.getName();
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket(bucketName)
                    .object(name)
                    .stream(inputStream, file.length(), -1)
                    .contentType(contentType.split(";")[0])
                    .build();

            // 执行上传操作
            minioClient.putObject(args);
            IOUtils.closeQuietly(inputStream);

            String message = folder + "版本的安装包已上传至 http://package.bhxz.host:9000 文件管理系统，文件路径为:" + name;

            String s = BHUtils.pushWebhookBotNotify(restTemplate, webhookUrlCenter7, message);
            log.error(s);
            log.error("File uploaded successfully.");
            return ResponseEntity.ok("File uploaded successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Error uploading file: " + e.getMessage());
            return ResponseEntity.status(500).body("Error uploading file: " + e.getMessage());
        }
    }

    @PostMapping("/center6/uploadFile")
    @ApiOperation(value = "6.0安装包上传接口")
    public ResponseEntity<String> uploadCenter6Package() {
        String fileUrl = "D:\\package\\center6\\BSServerSetup.exe";
        String folder = "6.0.0.17";
        BHUtils.createFile(propertiesCenter6);
        String propertiesStr = BHUtils.readFile(propertiesCenter6);
        Properties properties = new Properties();
        InputStream input = null;
        OutputStream output = null;
        try {
            if (StringUtils.isNotBlank(propertiesStr)){
                input = new FileInputStream(propertiesCenter6);
                properties.load(input);
                fileUrl = properties.getProperty("fileUrl");
                folder = properties.getProperty("version");
                String newVersion = BHUtils.incrementVersion(folder);
                properties.setProperty("version", newVersion);
                output = new FileOutputStream(propertiesCenter6);
                properties.store(output,"update version");
            }else {
                properties.setProperty("fileUrl","D:\\package\\center6\\BSServerSetup.exe");
                properties.setProperty("version", "6.0.0.17");
                output = new FileOutputStream(propertiesCenter6);
                properties.store(output, "init properties");
            }
        } catch (IOException e) {
            log.error("未读取到配置文件信息：" + e.getMessage());
            throw new RuntimeException(e);
        } finally {
            try {
                output.close();
                input.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        File file = new File(fileUrl);
        try (
                InputStream inputStream = new FileInputStream(file)
        ) {
            Tika tika = new Tika();
            String contentType = tika.detect(file);
            // 设置存储桶名称
            String bucketName = "package";

//            BHUtils.bucketExistsAndCreate(bucketName, minioClient);

            String name = "center6/" + folder + "/" + file.getName();
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket(bucketName)
                    .object(name)
                    .stream(inputStream, file.length(), -1)
                    .contentType(contentType.split(";")[0])
                    .build();

            // 执行上传操作
            minioClient.putObject(args);
            IOUtils.closeQuietly(inputStream);

            String message = folder + "版本的安装包已上传至 http://package.bhxz.host:9000 文件管理系统，文件路径为:" + name;

            String s = BHUtils.pushWebhookBotNotify(restTemplate, webhookUrlCenter7, message);
            log.error(s);
            log.error("File uploaded successfully.");
            return ResponseEntity.ok("File uploaded successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Error uploading file: " + e.getMessage());
            return ResponseEntity.status(500).body("Error uploading file: " + e.getMessage());
        }
    }

    @PostMapping("/subway/uploadFile")
    @ApiOperation(value = "地铁安装包上传接口")
    public ResponseEntity<String> uploadSubwayPackage() {
        String fileUrl = "D:\\package\\subway\\BSServerSetup.exe";
        String folder = "6.1.0.19";
        BHUtils.createFile(propertiesSubway);
        String propertiesStr = BHUtils.readFile(propertiesSubway);
        Properties properties = new Properties();
        InputStream input = null;
        OutputStream output = null;
        try {
            if (StringUtils.isNotBlank(propertiesStr)){
                input = new FileInputStream(propertiesSubway);
                properties.load(input);
                fileUrl = properties.getProperty("fileUrl");
                folder = properties.getProperty("version");
                String newVersion = BHUtils.incrementVersion(folder);
                properties.setProperty("version", newVersion);
                output = new FileOutputStream(propertiesSubway);
                properties.store(output,"update version");
            }else {
                properties.setProperty("fileUrl","D:\\package\\subway\\BSServerSetup.exe");
                properties.setProperty("version", "6.1.0.19");
                output = new FileOutputStream(propertiesSubway);
                properties.store(output, "init properties");
            }
        } catch (IOException e) {
            log.error("未读取到配置文件信息：" + e.getMessage());
            throw new RuntimeException(e);
        }finally {
            try {
                output.close();
                input.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        File file = new File(fileUrl);
        try (
                InputStream inputStream = new FileInputStream(file)
        ) {
            Tika tika = new Tika();
            String contentType = tika.detect(file);
            // 设置存储桶名称
            String bucketName = "package";

//            BHUtils.bucketExistsAndCreate(bucketName, minioClient);

            String name = "subway/" + folder + "/" + file.getName();
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket(bucketName)
                    .object(name)
                    .stream(inputStream, file.length(), -1)
                    .contentType(contentType.split(";")[0])
                    .build();

            // 执行上传操作
            minioClient.putObject(args);
            IOUtils.closeQuietly(inputStream);

            String message = folder + "版本的安装包已上传至 http://package.bhxz.host:9000 文件管理系统，文件路径为:" + name;

            String s = BHUtils.pushWebhookBotNotify(restTemplate, webhookUrlCenter7, message);
            log.error(s);
            log.error("File uploaded successfully.");
            return ResponseEntity.ok("File uploaded successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Error uploading file: " + e.getMessage());
            return ResponseEntity.status(500).body("Error uploading file: " + e.getMessage());
        }
    }

    @PostMapping("/delete")
    public ResponseEntity<String> deleteFile() {

        String bucketName = "package";
        RemoveObjectArgs args = RemoveObjectArgs.builder()
                .bucket(bucketName)
                .object("e44bf194-ba15-4c81-9881-f1e8899cf739_logo.png")
                .build();
        try {
            minioClient.removeObject(args);
            return ResponseEntity.ok("File uploaded successfully.");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }


}
