@echo off
cd %~dp0
set JAVA_BINARY=jre\bin\java
set /p mem=<MaxMemory.txt
%JAVA_BINARY% -Xmx%mem% -jar mcl.jar %*
