#!/bin/bash

cp ./config/lxqt/*.conf $HOME/.config/lxqt/
cp ./config/autostart/*.desktop $HOME/.config/autostart/
cp ./config/redshift.conf $HOME/.config/
cp ./local/share/file-manager/actions/*.desktop $HOME/.local/share/file-manager/actions/

sudo apt-get install redshift-gtk zip
