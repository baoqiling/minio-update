@echo off

set "url=https://jenkins.bhxz.host/view/center7/job/LCDP_UI/lastSuccessfulBuild/execution/node/3/ws/dist/*zip*/dist.zip"
set "downloadPath=D:\package\center7\ui\lcdp_ui_dist.zip"
set "unzipPath=D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui_dist"

REM 下载ZIP文件
echo Downloading...

call move  D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui_bak

call curl --insecure  "%url%" --user deploy:bhxz.dev.0328 -o  "%downloadPath%"

if %errorlevel% equ 0 (
    REM 下载成功后解压文件
    echo Unzipping...
    powershell Expand-Archive -Force   -Path "%downloadPath%" -DestinationPath "%unzipPath%"
) else (
    echo Download failed.
)
call move  D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui_dist\dist D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui
call rmdir /s /q "D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui_bak"
call rmdir /s /q "D:\package\center7\BHWebServer\dcenter\dcenter\lib\lcdp_ui_dist"