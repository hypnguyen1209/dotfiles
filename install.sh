#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && echo -e "Run script with sudoer\n" && exit 1

[ -f "/etc/os-release" ] && {
	source /etc/os-release
    [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" =~ "ubuntu" ]]
} || {
    OS=$(lsb_release -si 2>&-)
    [[ "$OS" == "Ubuntu" ]] || [[ "$OS" == "LinuxMint" ]]  || [[ "$OS" == "neon" ]] || {
        echo "Abort, this script is only intended for Ubuntu-like distros"
        exit 2
    }
}

apt update -y

apt upgrade -y

apt install -y git \
	curl \
	build-essential \
	python3-pip \
	python3-venv \
	nmap \
	make \
	unzip \
	zip \
	tar \
	p7zip-full \
	lsb-release \
	ca-certificates \
	apt-transport-https \
	software-properties-common \
	nginx \
	gnupg \
	autoconf \
	zsh

pip3 install --upgrade pip

bash git/git-config.sh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp .zshrc $HOME/.zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp .p10k.zsh $HOME/.p10k.zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/zsh-syntax-highlighting
