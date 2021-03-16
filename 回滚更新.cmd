@echo off
cd %~dp0
powershell -ExecutionPolicy Bypass ./main.ps1 -r
pause
