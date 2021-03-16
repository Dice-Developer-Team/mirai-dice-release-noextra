#!/bin/bash
cd $(dirname $0)
LD_PRELOAD=./data/MiraiNative/CQP.dll java -Dmirai.slider.captcha.supported -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
