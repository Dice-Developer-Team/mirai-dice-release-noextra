@echo off
chcp 936 >nul
cd %~dp0
if not exist main.ps1 (
	echo 未找到一份有效的Mirai Dice 安装（是否已经解压？）
	pause
	goto :EOF
)
set POWERSHELL_EXEC=powershell
powershell -Command exit
if errorlevel 1 (
    echo 警告：找不到系统组件powershell，这可能代表系统已经损坏。正在使用pwsh
    set POWERSHELL_EXEC=pwsh
    pwsh -Command exit
    if errorlevel 1 (
	    echo 错误：找不到pwsh，请访问 https://aka.ms/powershell-release?tag=stable 手动安装PowerShell 7 后重试
		echo 按任意键后将尝试打开下载页面（通常你需要下载并安装PowerShell-x.x.x-win-x64.msi）
        pause
		rundll32 url.dll,FileProtocolHandler https://aka.ms/powershell-release?tag=stable
        exit
    )
)
%POWERSHELL_EXEC% -ExecutionPolicy Bypass .\main.ps1
pause