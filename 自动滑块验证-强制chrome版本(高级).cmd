@echo off
echo Mirai ������֤-ǿ��ָ��Chrome�汾
echo ���w4123 20210315
cd %~dp0
set /p chromever=������chrome�汾��Ĭ��Ϊ87.0.4280.141��
if "%chromever%"=="" (set chromever=87.0.4280.141)
copy /Y .\slider\mirai-login-solver-selenium* .\plugins >nul 2>nul
set JAVA_BINARY=java
set /p mem=<MaxMemory.txt
%JAVA_BINARY% -Xmx%mem% -Dmxlib.selenium.chrome.version=%chromever% -jar mcl.jar %*
