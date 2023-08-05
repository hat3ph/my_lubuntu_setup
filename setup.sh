#!/bin/bash

# install additional packages
sudo apt-get install redshift-gtk rar -y

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

# setup buuf icon themes
mkdir -p $HOME/.icons
wget -P /tmp http://buuficontheme.free.fr/buuf3.42.tar.xz
tar -xvf /tmp/buuf*.tar.xz -C $HOME/.icons
echo "Remember to logoff and choose the new icon themes from LXQt Apperance Configuration."

# setup my customer bash alias
cat >> $HOME/.bashrc << 'EOF'

alias temps='watch -n 1 sensors amdgpu-* drivetemp-* k10temp-* asus_wmi_sensors-*'
alias syslog='tail -f /var/log/syslog'
EOF
