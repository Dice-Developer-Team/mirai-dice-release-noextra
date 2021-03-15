@echo off
echo Mirai 滑块验证-强制指定Chrome版本
echo 溯洄w4123 20210315
cd %~dp0
set /p chromever=请输入chrome版本（默认为87.0.4280.141）
if "%chromever%"=="" (set chromever=87.0.4280.141)
copy /Y .\slider\mirai-login-solver-selenium* .\plugins >nul 2>nul
set JAVA_BINARY=java
set /p mem=<MaxMemory.txt
%JAVA_BINARY% -Xmx%mem% -Dmxlib.selenium.chrome.version=%chromever% -jar mcl.jar %*
