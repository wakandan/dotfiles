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

    #flux
	sudo add-apt-repository -y ppa:kilian/f.lux

    #spotify
    sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

	sudo apt-get update -qq
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

function setup_git_config {
    git config --global user.email "wakandan@gmail.com"
    git config --global user.name "Dang Nguyen Anh Khoa"
}

function install_packages {
	echo "=== Install packages ==="
	sudo apt-get install -y gparted git-core
    sudo apt-get install -y python-gst0.10 gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly python-wnck
}

function install_spotify {
    current_folder=`pwd`
    sudo apt-get install spotify-client
    #install blockify
    git clone https://github.com/mikar/blockify /tmp/blockify 
    cd /tmp/blockify
    pip install 
    cd $current_folder
    exit 0
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

add_sources
install_packages
setup_git_config
init_dot_files
install_flux
install_vim_plugins
install_zsh
install_python_virtualenv
install_spotify
