#!/bin/bash
path=$(dirname "$0")
cd "$path"
java -Dmirai.slider.captcha.supported -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
