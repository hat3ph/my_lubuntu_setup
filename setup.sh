#!/bin/bash

# install additional packages
sudo apt-get install redshift-gtk zip

cp ./config/lxqt/*.conf $HOME/.config/lxqt/
cp ./config/autostart/*.desktop $HOME/.config/autostart/
cp ./config/redshift.conf $HOME/.config/

# create file-manager actions for unzip zip files
mkdir -p $HOME/.local/share/file-manager/actions
cp ./local/share/file-manager/actions/*.desktop $HOME/.local/share/file-manager/actions/
