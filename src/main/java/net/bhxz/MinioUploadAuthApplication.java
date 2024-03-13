package net.bhxz;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/***
 * @ClassName ${NAME}
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/2/29 16:30 
 */
@SpringBootApplication(scanBasePackages = "net.bhxz.*")
public class MinioUploadAuthApplication {
    public static void main(String[] args) {
        SpringApplication.run(MinioUploadAuthApplication.class, args);
    }
}
