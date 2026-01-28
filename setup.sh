#!/bin/bash
set -e

echo "please enter username for which you want to do the setup"
echo
read USERNAME

if ! getent passwd "$USERNAME" > /dev/null; then
  echo "given account $USERNAME not presented in the system"
  exit 1
fi

family="debian"
export INSTALLER="apt"
export PKG_QUERY="dpkg -s"
PACKAGES_TO_INSTALL="git vim zsh fzf nodejs npm build-essential dkms linux-headers-$(uname -r) ufw ffmpeg libavcodec-extra vlc curl wget htop unzip zip tlp tlp-rdw arc-theme papirus-icon-theme podman rsync ttf-mscorefonts-installer p7zip-full gdebi"
if [ -f /etc/redhat-release ] ; then 
  echo "you are using redhat family OS"
  family="redhat"
  export INSTALLER="yum"
  export PKG_QUERY="rpm -qa"
  PACKAGES_TO_INSTALL="git vim zsh fzf nodejs npm make automake gcc gcc-c++ kernel-devel dkms kernel-devel-$(uname -r) ffmpeg libavcodec-free  libavcodec-free-devel vlc curl wget htop unzip zip tlp tlp-rdw arc-theme papirus-icon-theme podman rsync p7zip"
fi

echo "basic package installing...."

function _cacheUpdate() {
  sudo "$INSTALLER" update 
}

function _upgradePkgs() {
  sudo "$INSTALLER" upgrade -y 
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
    echo "$INSTALLER cache updated already"
    return;
  fi
  _cacheUpdate
  _upgradePkgs
}
    

updateCache

echo "fetching installed packages"

INSTALLED_PKGS=$($INSTALLER list --installed | awk -F'/' 'NR>1 {print $1}')


for pkg in $PACKAGES_TO_INSTALL 
do
  if "$PKG_QUERY $pkg" &> /dev/null ; then 
    echo "$pkg installed"
  else
    sudo $INSTALLER install $pkg -y 
  fi
done

SERVICES_TO_BE_ENABLED="tlp podman ufw"
if [[ "$family" == "redhat" ]] ; then 
  SERVICES_TO_BE_ENABLED="tlp podman"
fi

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
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --directory-prefix /tmp/
  sudo gdebi /tmp/google-chrome-stable_current_amd64.deb
  rm  /tmp/google-chrome-stable_current_amd64.deb
fi

if [ ! -d /home/$USERNAME/bin ] ; then
  mkdir /home/$USERNAME/bin
fi

sudo chown  -R $USERNAME: /home/$USERNAME/bin/
cp -R ./bin/ /home/$USERNAME/


echo "setting zshrc"
if [ ! -f /home/$USERNAME/.zshrc ] ; then 
   cp ./zshrc /home/$USERNAME/.zshrc
   curl -L git.io/antigen > /home/$USERNAME/bin/antigen.zsh

else 

  echo "seems you have zsh setup already, shall override ( y/?)?"
  read response
  if [[ "$response == "y"" || "$response" == "Y" ]] ; then 
    cp /home/$USERNAME/.zshrc /home/$USERNAME/zshrc.bkp
    echo "backup taken to /home/$USERNAME/zshrc.bkp "
    cp zshrc /home/$USERNAME/.zshrc  
  fi
fi 

echo "zsh setup done"

echo "setting vim"
echo "...installing vundle"
if [ ! -d /home/$USERNAME/.vim/bundle/Vundle.vim ] ; then 
  git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
  cp vimrc /home/$USERNAME/.vimrc
  vim +PluginInstall +qall
  cd /home/$USERNAME/.vim/bundle/coc.nvim && npm ci 
  cd -
fi 
echo "vim setup completd"

FONTS_DIRECTORY="/home/$USERNAME/.fonts"

rsync -avzrp fonts $FONTS_DIRECTORY
fc-cache -f -v > /dev/null
echo "setting up fonts completed"

echo "setting xfce terminal themes"
TERMINAL_THEME_DIR="/home/$USERNAME/.local/share/xfce4/terminal/colorschemes/"
mkdir -p $TERMINAL_THEME_DIR
rsync -avh ./mariana.theme ./nord.theme $TERMINAL_THEME_DIR
echo "terminal themes copies successfully"

if [ -f /sys/class/power_supply/BAT0/charge_control_start_threshold ] ; then 
  echo "80" |  sudo tee -a /sys/class/power_supply/BAT0/charge_control_start_threshold > /dev/null
fi

if [ -f /sys/class/power_supply/BAT0/charge_control_end_threshold ] ; then 
  echo "90" | sudo tee -a  /sys/class/power_supply/BAT0/charge_control_end_threshold > /dev/null
fi
