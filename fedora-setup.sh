#!/bin/bash

scriptdir=$(pwd)
cd /tmp

# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------

# Preparation ------------------------------------------------------------------

sudo dnf remove -y gnote xviewer hexchat thunderbird transmission-common transmission-gtk rhythmbox pidgin xawtv dnfdragora-updater

sudo dnf upgrade -y

# Installation -----------------------------------------------------------------

essential="terminator git copyq audacious gimp samba adb flameshot curl tlp piper gstreamer1-plugin-openh264"
utilities="barrier cheese htop cloc neofetch"
qemukvm="qemu-kvm bridge-utils virt-manager ebtables iptables dnsmasq"
fun="cmatrix"

sudo dnf install -y $essential $utilities $qemukvm $fun

# Terminal ---------------------------------------------------------------------

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Zsh + p10k (taken from https://christitus.com/zsh/)
sudo dnf install -y zsh zsh-syntax-highlighting autojump zsh-autosuggestions && touch "$HOME/.cache/zshhistory" && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc && if [ -f "/bin/zsh" ]; then chsh -s /bin/zsh $USER; else echo "ZSH wasn't installed correctly"; fi

# MesloLGS fonts
sudo mkdir meslolgs && cd meslolgs && sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf && cd ../ && sudo mv meslolgs /usr/share/fonts

# Communication ----------------------------------------------------------------

# Discord
wget -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz" && tar -xzf discord.tar.gz && sudo mv Discord /opt

# Tutanota desktop
# wget "https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage" && sudo mv tutanota-desktop-linux.AppImage /opt && sudo chmod +x /opt/tutanota-desktop-linux.AppImage && wget -O tutanota-desktop.png "https://raw.githubusercontent.com/tutao/tutanota/master/resources/desktop-icons/icon/512.png" && sudo mv tutanota-desktop.png /usr/share/icons

# Browsers ---------------------------------------------------------------------

# Min
wget -O min.rpm "https://github.com/minbrowser/min/releases/download/v1.17.1/min-1.17.1-1.x86_64.rpm" && sudo dnf install -y ./min.rpm

# Brave
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ && sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc && sudo dnf install -y brave-browser

# Rambox
wget -O Rambox.AppImage "https://github.com/ramboxapp/community-edition/releases/download/0.7.7/Rambox-0.7.7-linux-x86_64.AppImage" && sudo mv Rambox.AppImage /opt && sudo chmod +x /opt/Rambox.AppImage

# Other ------------------------------------------------------------------------

# youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && sudo chmod a+rx /usr/local/bin/youtube-dl

# scrcpy
sudo dnf copr enable zeno/scrcpy -y && sudo dnf -y install scrcpy

# Gestures
sudo gpasswd -a $USER input && sudo dnf install -y xdotool wmctrl && cd /tmp && git clone https://github.com/bulletmark/libinput-gestures.git && cd libinput-gestures/ && sudo make install && libinput-gestures-setup autostart && libinput-gestures-setup start

# Teamviewer (commented out, because the most recent version causes problems)
# wget -O teamviewer.rpm "https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm" && sudo dnf install -y ./teamviewer.rpm

# Nextcloud desktop
wget -O nextcloud-desktop.AppImage "https://github.com/nextcloud/desktop/releases/download/v3.0.3/Nextcloud-3.0.3-x86_64.AppImage" && sudo mv nextcloud-desktop.AppImage /opt && sudo chmod +x /opt/nextcloud-desktop.AppImage

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# OBS studio (if you are running it separately, run it with bash)
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && sudo dnf install -y obs-studio 

# Programming ------------------------------------------------------------------

echo -en "\007" && spd-say "Installing programming apps, you will need to interfere!"

sudo dnf install -y haskell-platform godot

# Vimx (for clipboard support)
sudo apt install -y vimx

# Vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# lazygit
sudo dnf copr enable atim/lazygit -y && sudo dnf install -y lazygit

# MySQL (refer to https://stackoverflow.com/a/52216111/12036073 if you want to set a weak password, ONLY DO IT FOR TESTING PURPOSES)
sudo dnf install https://repo.mysql.com//mysql80-community-release-fc31-1.noarch.rpm && sudo dnf install -y mysql-community-server && sudo systemctl start mysqld && sudo systemctl enable mysqld && echo "Your root temporary password: " && sudo grep 'temporary password' /var/log/mysqld.log && sudo mysql_secure_installation

sudo dnf autoremove -y

echo
echo "Done! Please reboot!" & echo -en "\007" & spd-say "Done! Please reboot!"
echo
