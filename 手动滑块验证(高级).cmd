@echo off
echo Mirai �ֶ���������֤�����mirai.slider.captcha.supported��
echo ���w4123 20210315
cd %~dp0
del /Q .\plugins\mirai-login-solver-selenium* >nul 2>nul
set JAVA_BINARY=java
set /p mem=<MaxMemory.txt
%JAVA_BINARY% -Xmx%mem% -Dmirai.slider.captcha.supported -jar mcl.jar %*
