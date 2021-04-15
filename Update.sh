#!/bin/bash
path=$(dirname -- "$0")
cd "$path"
git fetch --depth=1
git reset --hard origin/master
