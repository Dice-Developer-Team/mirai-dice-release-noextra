@echo off
chcp 936 >nul
cd %~dp0
if not exist main.ps1 (
	echo δ�ҵ�һ����Ч��Mirai Dice ��װ���Ƿ��Ѿ���ѹ����
	pause
	goto :EOF
)
powershell -ExecutionPolicy Bypass .\main.ps1 -r
pause
