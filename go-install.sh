#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && echo -e "Run script with sudoer\n" && exit 1

if [ -n "$($SHELL -c 'echo $ZSH_VERSION')" ]; then
    shell_profile="$HOME/.zshrc"
elif [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then
    shell_profile="$HOME/.bashrc"
fi

OS=linux
ARCH=amd64
TEMP_DIRECTORY=$(mktemp -d)

read -p 'Version: ' $VERSION

[ -z "$GOROOT" ] && GOROOT="$HOME/.go"
[ -z "$GOPATH" ] && GOPATH="$HOME/go"

wget https://go.dev/dl/go$VERSION.$OS-$ARCH.tar.gz" -O "$TEMP_DIRECTORY/go.tar.gz"

mkdir -p "$GOROOT"

rm -rf /usr/local/go && tar -C /usr/local -xzf "$TEMP_DIRECTORY/go.tar.gz"

echo 'export PATH=$PATH:/usr/local/go/bin' >> $shell_profile

go version

rm -f "$TEMP_DIRECTORY/go.tar.gz"

