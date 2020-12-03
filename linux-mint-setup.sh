#!/bin/bash

scriptdir=$(pwd)
cd /tmp

# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------

# Preparation ------------------------------------------------------------------

sudo apt purge -y gnote xviewer hexchat thunderbird transmission-common transmission-gtk rhythmbox

# Remove snapd
sudo rm -rf /var/cache/snapd & rm -rf ~/snap && sudo apt purge -y snapd

sudo add-apt-repository ppa:libratbag-piper/piper-libratbag-git -y
sudo add-apt-repository ppa:obsproject/obs-studio -y

sudo apt update && sudo apt upgrade -y

# Installation -----------------------------------------------------------------

essential="terminator git copyq audacious gimp samba adb flameshot curl tlp piper ffmpeg apt-transport-https"
utilities="barrier cheese htop cloc neofetch scrcpy obs-studio"
qemukvm="qemu-kvm bridge-utils virt-manager gir1.2-spiceclientglib-2.0 gir1.2-spiceclientgtk-3.0 ebtables iptables dnsmasq qemu-utils"
fun="cmatrix"

sudo apt install -y $essential $utilities $qemukvm $fun

# Terminal ---------------------------------------------------------------------

# Zsh + p10k (taken from https://christitus.com/zsh/)
sudo apt install -y zsh zsh-syntax-highlighting autojump zsh-autosuggestions && touch "$HOME/.cache/zshhistory" && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc && if [ -f "/bin/zsh" ]; then chsh -s /bin/zsh $USER; else echo "ZSH wasn't installed correctly"; fi

# Communication ----------------------------------------------------------------

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&&format=deb" && sudo apt install -y ./discord.deb

# Caprine
wget -O caprine.deb "https://github.com/sindresorhus/caprine/releases/download/v2.51.0/caprine_2.51.0_amd64.deb" && sudo apt install -y ./caprine.deb && wget -O caprine.png "https://github.com/sindresorhus/caprine/raw/master/media/Icon.png" && sudo mv ./caprine.png /usr/share/icons/

# Signal desktop
wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add - && echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list && sudo apt update && sudo apt install -y signal-desktop

# ProtonMail desktop (unofficial)
wget -O protonmail-desktop-unofficial.deb "https://github.com/protonmail-desktop/application/releases/download/1.0.4/protonmail-desktop-unofficial_1.0.4_amd64.deb" && sudo apt install -y ./protonmail-desktop-unofficial.deb

# Tutanota desktop
wget "https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage" && sudo mv tutanota-desktop-linux.AppImage /opt && sudo chmod +x /opt/tutanota-desktop-linux.AppImage

# Slack
wget -O slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.10.3-amd64.deb" && sudo apt install -y ./slack.deb

# Skype
wget -O skype.deb "https://go.skype.com/skypeforlinux-64.deb" && sudo apt install -y ./skype.deb

# Browsers ---------------------------------------------------------------------

# Min
wget -O min.deb "https://github.com/minbrowser/min/releases/download/v1.16.1/min_1.16.1_amd64.deb" && sudo apt install -y ./min.deb

# Brave
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list && sudo apt update && sudo apt install -y brave-browser

# Wexond
wget -O wexond.deb "https://github.com/wexond/desktop/releases/download/v5.1.0/wexond_5.1.0_amd64.deb" && sudo apt install -y ./wexond.deb

# Other ------------------------------------------------------------------------

# youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && sudo chmod a+rx /usr/local/bin/youtube-dl

# Gestures
gpasswd -a $USER input && sudo apt install -y xdotool wmctrl libinput-tools && cd /tmp && git clone https://github.com/bulletmark/libinput-gestures.git && cd libinput-gestures/ && make install && libinput-gestures-setup autostart && libinput-gestures-setup start

# Teamviewer
get https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc && apt-key add TeamViewer2017.asc && sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list' && apt update && apt install -y teamviewer

# Nextcloud desktop
sudo add-apt-repository ppa:nextcloud-devs/client -y && sudo apt-get update && sudo apt install -y nextcloud-desktop

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# Programming ------------------------------------------------------------------

echo -en "\007" && spd-say "Installing programming apps, you will need to interfere!"

sudo apt install -y haskell-platform

# Vim + vim-plug
sudo apt install -y vim vim-gtk && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# lazygit
sudo add-apt-repository ppa:lazygit-team/release -y && sudo apt-get update && sudo apt-get install -y lazygit

# Monodevelop
sudo apt install -y dirmngr && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list && apt update && sudo apt install -y monodevelop

# Godot (mono) ; note: you'll need to manually add it to the main cinnamon menu
wget "https://downloads.tuxfamily.org/godotengine/3.2.1/mono/Godot_v3.2.1-stable_mono_x11_64.zip" && sudo unzip Godot*.zip -d /opt && sudo chmod +x /opt/Godot*/Godot*

# MySQL + MySQL Workbench
curl -OL https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb && dpkg -i mysql-apt-config_0.8.15-1_all.deb && apt update && sudo apt install -y mysql-server -y && mysql_secure_installation && sudo apt install -y mysql-workbench-community

sudo apt autoremove -y

echo
echo "Done! Please reboot!" & echo -en "\007" & spd-say "Done! Please reboot!"
echo

echo "You'll need to manually install MesloLGS font. No need to configure anything. https://github.com/romkatv/powerlevel10k#manual-font-installation"
