#!/bin/bash

#if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root"
#   exit 1
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
    success 'add sources'

    #flux
    sudo add-apt-repository -y ppa:kilian/f.lux

    #spotify
    sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free"
    sudo apt-key adv -y --keyserver keyserver.ubuntu.com --recv-keys 94558F59

    #numix
    sudo add-apt-repository -y ppa:numix/ppa 

    #java jdk
    sudo add-apt-repository -y ppa:webupd8team/java

    info 'update apt-get'
    sudo apt-get update -qq
    success 'added sources'
}

function info {
    echo -e "\e[94m[info] $1\e[0m"
}

function success {
    echo -e "\e[32m[success] $1\e[0m"
}

# Install flux, the app to protect my eyes
function install_flux {
    success "install flux"
    old_dir=`pwd`
    cd /tmp
    sudo apt-get -y install libxxf86vm1:i386 fluxgui
    info 'patching xflux to support multiple monitor'
    if [ ! -f '/tmp/xflux-pre.tgz' ]; then
        info 'downloading xflux patch'
        wget https://herf.org/flux/xflux-pre.tgz    #support multiple monitor flux
    else
        info 'reusing downloaded patch file'
    fi
    tar -vxzf xflux-pre.tgz
    info 'moving flux to /bin'
    sudo mv xflux /usr/bin/xflux
    success "installed flux, run with /usr/bin/xflux"
    cd $old_dir
}

function init_dot_files {
    success 'init dot files (.vimrc, .zshrc)'
    git_clone_or_update git@github.com:wakandan/dotfiles.git ~/.config/dotfiles 
    info 'linking .zshrc'
    ln -s /home/akai/.config/dotfiles/.zshrc /home/akai/.zshrc
    info 'linking .vimrc'
    ln -s /home/akai/.config/dotfiles/.vimrc /home/akai/.vimrc 
    success 'setup dot files'
}

function install_vim_plugins {
    success 'install vim plugins'
    mkdir -p ~/.vim/bundle
    sudo apt-get install -y vim
    git_clone_or_update https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
    success 'installed vim plugins'
}

function setup_git_config {
    success 'config git'
    git config --global user.email "wakandan@gmail.com"
    git config --global user.name "Dang Nguyen Anh Khoa"
    git config --global core.editor vim
    success 'configured git'
}

function install_packages {
    success 'install packages'
    sudo apt-get install -y gparted git-core
    sudo apt-get install -y python-gst0.10 gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly python-wnck
    sudo apt-get install -y silversearcher-ag

    #xclip - tool to copy content to clipboard, use as xclip -sel clip < file
    sudo apt-get install -y xclip

    #install oracle jdk8, auto set jdk environment variables as well 
    #auto accept licence
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

    success 'installed packages'
}

function install_spotify {
    old_dir=`pwd`
    success 'install spotify'
    sudo apt-get install spotify-client
    info 'install blockify'
    git clone https://github.com/mikar/blockify /tmp/blockify 
    cd /tmp/blockify
    pip install 
    success 'installed spotify'
    cd $old_dir
}


function install_zsh {
    success 'install zsh'
    sudo apt-get install -y zsh
    info 'change default shell to zsh'
    chsh -s /bin/zsh    
    info 'install oh-my-zsh'
    wget –no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O – | sh 
    success 'installed ssh'
}

function install_python_virtualenv {
    old_dir=`pwd`
    success 'install python virtualenv'
    info 'install pip & virtual env'
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
    sudo pip install virtualenv
    cd ~    #install virtualenv into home folder
    info 'creating virtual env'
    virtualenv env
    source ~/env/bin/activate
    success 'installed python virtualenv'
    cd $old_dir
}

function install_unity_tweak_tool_n_numix_theme {
    success 'install numix'
    sudo apt-get install -y numix-gtk-theme numix-icon-theme-circle 
    sudo apt-get install -y numix-wallpaper-notd
    sudo apt-get install -y unity-tweak-tool
    success 'installed numix'
}

function generate_ssh_key {
    success 'generating ssh key'
    if [ -f ~/.ssh/id_rsa.pub ]; then
        success 'public key found. this may not be needed...'
        return 
    fi

    ssh-keygen -t rsa -C "wakandan@gmail.com"
    info 'starting ssh-agent'
    eval "$(ssh-agent -s)"
    info 'copying ssh pub key to clipboard'
    xclip -sel clip < ~/.ssh/id_rsa.pub
    success 'public key copied to clipboard, please add it to github settings...'
    read
    success 'generated ssh key'
}

function install_calibre {
    success 'install calibre'
    sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
    success 'installed calibre'
}

add_sources
install_packages
#setup_git_config
#init_dot_files
#install_flux
#install_vim_plugins
#install_zsh
#install_python_virtualenv
#install_spotify
#install_unity_tweak_tool_n_numix_theme
#install_calibre
