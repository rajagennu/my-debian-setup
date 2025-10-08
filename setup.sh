#!/bin/bash
set -e
echo "basic package installing...."


function _cacheUpdate() {
  sudo apt update 
}

function _upgradePkgs() {
  sudo apt upgrade -y 
}

function updateCache() {
  if [ ! -f .date ] ; then 
    echo "$(date +%F)" > .date
   _cacheUpdate
   _upgradePkgs
    return;
  fi 
    
  lastUpdatedDate="$(cat .date | head -n 1)"
  currentDate="$(date +%F)"
  if [[ $currentDate == $lastUpdatedDate ]] ; then 
    echo "APT cache updated already"
    return;
  fi
  _cacheUpdate
  _upgradePkgs
}
    

updateCache

echo "fetching installed packages"

INSTALLED_PKGS=$(apt list --installed | awk -F'/' 'NR>1 {print $1}')
PACKAGES_TO_INSTALL="git vim zsh fzf nodejs npm build-essential dkms linux-headers-$(uname -r) ufw ffmpeg libavcodec-extra vlc curl wget htop unzip zip tlp tlp-rdw arc-theme papirus-icon-theme podman rsync"

for pkg in $PACKAGES_TO_INSTALL 
do
  if dpkg -s $pkg &> /dev/null ; then 
    echo "$pkg installed"
  else
    sudo apt install $pkg -y 
  fi
done

SERVICES_TO_BE_ENABLED="tlp podman ufw"
for service in $SERVICES_TO_BE_ENABLED
do
  if ! systemctl is-enabled $service ; then 
    echo "enabling $service ........"
    sudo systemctl enable --now $service 
    sleep 1
    if systemctl is-active $service ; then 
      echo "service :: $service is up and running"
    fi
  fi
done


if [ ! -f /usr/bin/google-chrome ] ; then 
  echo "Installing chrome " 
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb
  rm ./google-chrome-stable_current_amd64.deb
fi
  

echo "setting zshrc"
if [ ! -f ~/.zshrc ] ; then 
   cp -R ./bin ~/bin
	 chown  -R $USER: ~/bin
   cp zshrc ~/.zshrc 
fi 

echo "zsh setup done"

echo "setting vim"
echo "...installing vundle"
if [ ! -d /home/$USER/.vim/bundle/Vundle.vim ] ; then 
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp vimrc ~/.vimrc
  vim +PluginInstall +qall
  cd ~/.vim/bundle/coc.nvim && npm ci 
fi 
echo "vim setup completd"

FONTS_DIRECTORY="/home/$USER/.fonts"

rsync -avzrp fonts $FONTS_DIRECTORY
fc-cache -f -v > /dev/null
echo "setting up fonts completed"

echo "setting xfce terminal themes"
TERMINAL_THEME_DIR="/home/$USER/.local/share/xfce4/terminal/colorschemes/"
mkdir -p $TERMINAL_THEME_DIR
rsync -avh ./mariana.theme ./nord.theme $TERMINAL_THEME_DIR
echo "terminal themes copies successfully"
