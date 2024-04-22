call curl -k -X POST https://jenkins.bhxz.host/job/ivms/build --user deploy:117dec5e62c1b588c4b468778fe464a379
echo Waiting for 120 seconds...  
ping 127.0.0.1 -n 120 >nul  
echo Done waiting.
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/admin_server/target/admin_server-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\admin_server-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/bh5000_mysql/target/bh5000_mysql-6.0.0.jar	 --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\bh5000_mysql-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/bs/target/bs-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\bs-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/center/target/center-6.0.0.jar --user deploy:bhxz.dev.0328 -o 	D:\package\center7\BHWebServer\dcenter\dcenter\lib\center-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/config_server/target/config_server-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\config_server-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/dcenter_file/target/dcenter_file-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\dcenter_file-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/dcenter_sync/target/dcenter_sync-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\dcenter_sync-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/dcenter_user/target/dcenter_user-6.0.0.jar --user deploy:bhxz.dev.0328 -o D:\package\center7\BHWebServer\dcenter\dcenter\lib\dcenter_user-6.0.0.jar
call curl --insecure  https://jenkins.bhxz.host/view/center7/job/ivms/lastSuccessfulBuild/artifact/gateway/target/gateway-6.0.0.jar --user deploy:bhxz.dev.0328 -o 	D:\package\center7\BHWebServer\dcenter\dcenter\lib\gateway-6.0.0.jar
echo "success"
exit