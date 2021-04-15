#!/bin/bash
path=$(dirname -- "$0")
cd "$path"
java -Dmirai.slider.captcha.supported -jar mcl.jar
