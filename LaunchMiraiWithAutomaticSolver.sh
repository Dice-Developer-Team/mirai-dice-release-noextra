#!/bin/bash
path=$(dirname -- "$0")
cd "$path"
rm ./plugins/mirai-automatic-slider*
cp ./fslider/* ./plugins/
java -jar mcl.jar
