#!/bin/bash

# install additional packages
sudo apt-get install redshift-gtk rar lm-sensors -y

# setup disk drive temp module
echo drivetemp | sudo tee /etc/modules-load.d/drivetemp.conf

# setup sensors for ASUS X370 Crosshair
sudo cat > /etc/sensors.d/asus_wmi_sensors.conf << 'EOF'
chip "asus_wmi_sensors-virtual-0"

ignore fan4 # chassis fan 3
ignore fan5 # CPU optional fan
ignore fan6 # water pump
ignore fan7 # CPU opt fan
ignore fan8 # water flow
ignore temp5 # Tsensor 1 temp
ignore temp7 # water in temp
ignore temp8 # water out temp
EOF

# copy my LXQt and autostart configuration
mkdir -p $HOME/.config/{lxqt,autostart}
cp ./config/lxqt/*.conf $HOME/.config/lxqt/
cp ./config/autostart/*.desktop $HOME/.config/autostart/

# copy my redshift configuration
cp ./config/redshift.conf $HOME/.config/

# create file-manager actions directory
mkdir -p $HOME/.local/share/file-manager/actions
# actions file for extract rar file
cp ./local/share/file-manager/actions/rar-*.desktop $HOME/.local/share/file-manager/actions/
echo "Remember to change PCManFM-Qt's Archiver intergration to lxqt-archiver under Preferences > Advanced."
# actions to open terminal in desktop. Not need for LXQt v1.3
cp ./local/share/file-manager/actions/open_in_terminal.desktop $HOME/.local/share/file-manager/actions/

# setup buuf icon theme
mkdir -p $HOME/.icons
wget -P /tmp http://buuficontheme.free.fr/buuf3.46.tar.xz
tar -xvf /tmp/buuf*.tar.xz -C $HOME/.icons

# buuf icon from robson-66
#git clone https://github.com/robson-66/Buuf.git /tmp/Buuf
#mkdir -p $HOME/.icons/Buuf
#cp -r /tmp/Buuf/* $HOME/.icons/Buuf && rm -rf $HOME/.icons/Buuf/.git

# setup buuf-icons-for-plasma icon theme
git clone https://www.opencode.net/phob1an/buuf-icons-for-plasma.git /tmp/buuf-icons-for-plasma
mkdir -p $HOME/.icons/buuf-icons-for-plasma
cp -r /tmp/buuf-icons-for-plasma/{16x16,22x22,32x32,48x48,64x64,128x128,index.theme,licenses} $HOME/.icons/buuf-icons-for-plasma

# install Gruvbox-Plus-Dark icon theme
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git /tmp/gruvbox-plus-icon-pack
mkdir -p $HOME/.icons
cp -r /tmp/gruvbox-plus-icon-pack/Gruvbox-Plus-Dark $HOME/.icons/

echo "Remember to logoff and choose the new icon themes from LXQt Apperance Configuration."

# setup my customer bash alias
cat >> $HOME/.bashrc << 'EOF'

alias temps='watch -n 1 sensors amdgpu-* drivetemp-* k10temp-* asus_wmi_sensors-*'
alias syslog='tail -f /var/log/syslog'
EOF
