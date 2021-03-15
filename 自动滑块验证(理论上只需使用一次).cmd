@echo off
echo Mirai 滑块验证处理（其实只是简单的装一下mirai-login-solver-selenium）
echo 溯洄w4123 20210315
cd %~dp0
copy /Y .\slider\mirai-login-solver-selenium* .\plugins >nul 2>nul
set JAVA_BINARY=java
set /p mem=<MaxMemory.txt
%JAVA_BINARY% -Xmx%mem% -jar mcl.jar %*
