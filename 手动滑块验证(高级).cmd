@echo off
echo Mirai 手动处理滑块验证（添加mirai.slider.captcha.supported）
echo 溯洄w4123 20210526
cd %~dp0
powershell -ExecutionPolicy Bypass .\main.ps1 -s
