@echo off
cd %~dp0
if not exist main.ps1 (
	echo δ�ҵ�һ����Ч��Mirai Dice ��װ���Ƿ��Ѿ���ѹ����
	pause
	goto :EOF
)
setlocal enabledelayedexpansion
set POWERSHELL_EXEC=powershell
!POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
if errorlevel 1 (
    set POWERSHELL_EXEC=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
	!POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
    if errorlevel 1 (
        echo ���棺�Ҳ���ϵͳ���powershell������ܴ���ϵͳ�Ѿ��𻵡�����ʹ��pwsh
        set POWERSHELL_EXEC=pwsh
        !POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
        if errorlevel 1 (
            set POWERSHELL_EXEC=C:\Program Files\PowerShell\7\pwsh.exe
            !POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
            if errorlevel 1 (
                echo �����Ҳ���pwsh������� https://aka.ms/powershell-release?tag=stable �ֶ���װPowerShell 7 ������
                echo ��������󽫳��Դ�����ҳ�棨ͨ������Ҫ���ز���װPowerShell-x.x.x-win-x64.msi��
                pause
                rundll32 url.dll,FileProtocolHandler https://aka.ms/powershell-release?tag=stable
                exit
            )
        )
    )
)
!POWERSHELL_EXEC! -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\main.ps1 -u
pause