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

function check_or_add_ppa {
  ppa=$1
  if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    info "adding ppa $ppa"
    sudo add-apt-repository -y "ppa:"$ppa 
  fi
  info "added ppa $ppa"
}

function git_clone_or_update {
    current_folder=`pwd`
    repo=$1
    folder=$2
    if [ -d $folder ]; then
        git pull    
    else 
        git clone $repo $folder
    fi  
    cd $current_folder
}

# add all needed repositores, update and install
function add_sources {
    success 'add sources'

    #flux
    check_or_add_ppa 'ppa:kilian/f.lux'

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
    info 'linking .zshrc'
    ln -f -s $(pwd)/.zshrc /home/$USER/.zshrc
    info 'linking .vimrc'
    ln -f -s $(pwd)/.vimrc /home/$USER/.vimrc 
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
    sudo apt-get install -y gparted git-core curl
    sudo apt-get install -y python-gst0.10 gstreamer0.10-plugins-good python-wnck
    sudo apt-get install -y silversearcher-ag exuberant-ctags

    #xclip - tool to copy content to clipboard, use as xclip -sel clip < file
    sudo apt-get install -y xclip

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
    info 'install zsh'
    if ! $SHELL == '/bin/zsh'; then
      sudo apt-get install -y zsh
      info 'change default shell to zsh'
      chsh -s /bin/zsh    
      info 'install oh-my-zsh'
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
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
    virtualenv python_env
    source ~/python_env/bin/activate
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

function install_kvm {
     sudo apt-get install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
     sudo adduser akai kvm
     sudo adduser akai libvirtd
}

function swap_ctrl_caplocks {
  success 'swapping ctrl and caplocks'
  setxkbmap -option ctrl:swapcaps
  success 'done swapping ctrl and caplocks'
}

function install_chromium {
  check_or_add_ppa 'canonical-chromium-builds/stage'
  sudo apt-get update
  sudo apt-get install chromium-browser
}

function install_java8 {
  info 'installing java8'
  check_or_add_ppa 'webupd8team/java'
  sudo apt-get update
  sudo apt-get install oracle-java8-installer oracle-java8-set-default
  success 'done installing java8'
}

#add_sources
install_packages
setup_git_config
init_dot_files
#install_flux
install_vim_plugins
install_zsh
#install_python_virtualenv
#install_spotify
#install_unity_tweak_tool_n_numix_theme
#install_calibre
#install_kvm
install_chromium
install_java8
success 'you should restart your computer now'
