@echo off
chcp 936 >nul
cd %~dp0
if not exist main.ps1 (
	echo δ�ҵ�һ����Ч��Mirai Dice ��װ���Ƿ��Ѿ���ѹ����
	pause
	goto :EOF
)
set POWERSHELL_EXEC=powershell
powershell -Command exit
if errorlevel 1 (
    echo ���棺�Ҳ���ϵͳ���powershell������ܴ���ϵͳ�Ѿ��𻵡�����ʹ��pwsh
    set POWERSHELL_EXEC=pwsh
    pwsh -Command exit
    if errorlevel 1 (
	    echo �����Ҳ���pwsh������� https://aka.ms/powershell-release?tag=stable �ֶ���װPowerShell 7 ������
		echo ��������󽫳��Դ�����ҳ�棨ͨ������Ҫ���ز���װPowerShell-x.x.x-win-x64.msi��
        pause
		rundll32 url.dll,FileProtocolHandler https://aka.ms/powershell-release?tag=stable
        exit
    )
)
%POWERSHELL_EXEC% -ExecutionPolicy Bypass .\main.ps1
pause