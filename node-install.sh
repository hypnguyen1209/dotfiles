#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && echo -e "Run script with sudoer\n" && exit 1

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs