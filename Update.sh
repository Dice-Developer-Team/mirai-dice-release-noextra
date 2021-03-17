#!/bin/bash
cd $(dirname $0)
git fetch --depth=1
git reset --hard origin/master
