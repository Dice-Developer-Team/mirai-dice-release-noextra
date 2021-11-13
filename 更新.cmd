@echo off
cd %~dp0
if not exist main.ps1 (
	echo 未找到一份有效的Mirai Dice 安装（是否已经解压？）
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
        echo 警告：找不到系统组件powershell，这可能代表系统已经损坏。正在使用pwsh
        set POWERSHELL_EXEC=pwsh
        !POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
        if errorlevel 1 (
            set POWERSHELL_EXEC=C:\Program Files\PowerShell\7\pwsh.exe
            !POWERSHELL_EXEC! -NoLogo -NoProfile -Command exit
            if errorlevel 1 (
                echo 错误：找不到pwsh，请访问 https://aka.ms/powershell-release?tag=stable 手动安装PowerShell 7 后重试
                echo 按任意键后将尝试打开下载页面（通常你需要下载并安装PowerShell-x.x.x-win-x64.msi）
                pause
                rundll32 url.dll,FileProtocolHandler https://aka.ms/powershell-release?tag=stable
                exit
            )
        )
    )
)
!POWERSHELL_EXEC! -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\main.ps1 -u
pause