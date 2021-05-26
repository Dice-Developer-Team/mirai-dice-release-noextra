#!/data/data/com.termux/files/usr/bin/bash
# The hashbang above is used in case libtermux-exec is disabled by some random user
path=$(dirname -- "$0")
cd "$path"
rm ./plugins/mirai-automatic-slider*
termux-wake-lock
java -Dmirai.slider.captcha.supported -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
termux-wake-unlock
