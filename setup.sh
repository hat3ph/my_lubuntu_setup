#!/bin/bash

# install additional packages
sudo apt-get install redshift-gtk rar -y

cp ./config/lxqt/*.conf $HOME/.config/lxqt/
cp ./config/autostart/*.desktop $HOME/.config/autostart/
cp ./config/redshift.conf $HOME/.config/

# create file-manager actions directory
mkdir -p $HOME/.local/share/file-manager/actions
# actions file for extract rar file
cp ./local/share/file-manager/actions/rar-*.desktop $HOME/.local/share/file-manager/actions/
# actions to open terminal in desktop. Not need for LXQt v1.3
cp ./local/share/file-manager/actions/open_in_terminal.desktop $HOME/.local/share/file-manager/actions/
