#!/bin/bash

#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run as root"
#	exit 1
#fi

skip_update=

#check if can skip apt-get update
while [ "$#" -gt 0 ]; do 
	case $1 in 
		-h|--help)
			show_help
			exit
			;;
		-s|--skip-apt-update)
			skip_update=1
			exit
			;;
	esac
done

function git_clone_or_update {
	current_folder=`pwd`
	repo=$1
	folder=$2
	if [ -d $folder ]; then
		git pull 	
	else 
		git clone $repo
	fi 	
	cd $current_folder
}

# add all needed repositores, update and install
function add_sources {
	echo "=== Add sources ==="
	sudo add-apt-repository -y ppa:kilian/f.lux 	#flux
	sudo apt-get update
}

function install_flux {
	echo "=== Install flux ==="
	cd /tmp		#<=======================still in dir
	sudo apt-get -y install fluxgui
	wget https://herf.org/flux/xflux-pre.tgz 	#support multiple monitor flux
	tar -vxzf xflux-pre.tgz
	sudo mv xflux /usr/bin/xflux
}

function init_dot_files {
	echo "=== Init dot files ==="
	git_clone_or_update git@github.com:wakandan/dotfiles.git ~/.config/dotfiles 
	ln -s /home/akai/.config/dotfiles/.zshrc /home/akai/.zshrc
	ln -s /home/akai/.config/dotfiles/.vimrc /home/akai/.vimrc 
	
}

function install_vim_plugins {
	echo "=== Install vim plugins ==="
	mkdir -p ~/.vim/bundle
	sudo apt-get install -y vim
	git_clone_or_update https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
}

function install_packages {
	echo "=== Install packages ==="
	sudo apt-get install -y gparted git-core
}


function install_zsh {
	echo "=== Install zsh ==="
	#install zsh
	sudo apt-get install -y zsh
	chsh -s /bin/zsh 	#change default shell to zsh
	#install oh-my-zsh
	wget –no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O – | sh 
}

function install_python_virtualenv {
	echo "=== Install python virtualenv==="
	#install pip & virtualenv
	wget https://bootstrap.pypa.io/get-pip.py
	sudo python get-pip.py
	sudo pip install virtualenv
	cd ~	#install virtualenv into home folder
	virtualenv env
	source ~/env/bin/activate
}

#add_sources
#install_packages
init_dot_files
#install_flux
install_vim_plugins
#install_zsh
#install_python_virtualenv
