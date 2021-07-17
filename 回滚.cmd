@echo off
chcp 936 >nul
cd %~dp0
if not exist main.ps1 (
	echo 未找到一份有效的Mirai Dice 安装（是否已经解压？）
	pause
	goto :EOF
)
powershell -ExecutionPolicy Bypass .\main.ps1 -r
pause
