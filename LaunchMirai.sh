#!/bin/bash
path=$(dirname -- "$0")
cd "$path"
rm ./plugins/mirai-automatic-slider*
java -Dmirai.slider.captcha.supported -jar mcl.jar
