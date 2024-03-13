package net.bhxz.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/***
 * @ClassName MinioProperties
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/3/7 11:10 
 */
@ConfigurationProperties(prefix = "minio")
@Component
@Data
public class MinioProperties {

    private String endpoint;

    private String accessKey;

    private String secretKey;

    private Boolean secure;

    private String bucketName;

}
