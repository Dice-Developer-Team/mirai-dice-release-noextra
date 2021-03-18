#!/bin/bash
path=$(dirname "$0")
cd "$path"
LD_PRELOAD=./data/MiraiNative/CQP.dll java -Dmirai.slider.captcha.supported -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
