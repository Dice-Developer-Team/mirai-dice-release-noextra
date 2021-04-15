#!/bin/bash
path=$(dirname -- "$0")
cd "$path"
git reset --hard HEAD@{1}
