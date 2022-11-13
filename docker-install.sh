#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && echo -e "Run script with sudoer\n" && exit 1

curl -sS https://get.docker.com | sh