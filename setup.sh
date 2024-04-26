#!/bin/bash

extra_apps=yes # set yes to install extra apps
amdgpu_tearfree=yes # set yes to enable amdgpu tearfree
qemu=yes # set yes to install qemu and virt-manager
firefox_deb=yes # set yes to install firefox from official deb
sensors=yes # set yes to customize lm-sensors
lxqt_config=no # set yes to copy customized lxqt config
redshift_config=yes # set yes to copy customized redshift config
pcmanfmqt_rar=no # set yes to enable rar support in pcmanfm-qt
theming=yes # set yes to enable icon and theming
bashrc=yes # set yes to customized my bashrc

install () {
	# install additional packages
	if [[ $extra_apps == "yes" ]]; then
		sudo apt-get update
		sudo apt-get install geany rar lm-sensors -y
	fi

 	# xorg amdgpu tear free
  	if [[ $amdgpu_tearfree == "yes" ]]; then
		sudo cp ./config/20-amdgpu-tearfree.conf /etc/X11/xorg.conf.d/
   	fi

    	# install qemu and virt-manager
     	if [[ $qemu == "yes" ]]; then
     		sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
    	fi
     	
	# install firefox from official deb
	if [[ $firefox_deb == "yes" ]]; then
		sudo install -d -m 0755 /etc/apt/keyrings
		wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
			sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
		echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | \
  			sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
		echo -e "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000" | \
  			sudo tee /etc/apt/preferences.d/mozilla
		sudo apt-get update && sudo apt-get install firefox -y
	fi
	
	if [[ $sensors == "yes" ]]; then
		# setup disk drive temp module
		echo drivetemp | sudo tee /etc/modules-load.d/drivetemp.conf
	  
		# setup sensors for ASUS X370 Crosshair
		echo -e "chip "asus_wmi_sensors-virtual-0"\n" | sudo tee /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore fan4 # chassis fan 3" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore fan5 # CPU optional fan" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore fan6 # water pump" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore fan7 # CPU opt fan" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore fan8 # water flow" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore temp5 # Tsensor 1 temp" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore temp7 # water in temp" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
		echo "ignore temp8 # water out temp" | sudo tee -a /etc/sensors.d/asus_wmi_sensors.conf
	fi
	
	# copy my LXQt and autostart configuration
	if [[ $lxqt_config == "yes" ]]; then
		mkdir -p $HOME/.config/{lxqt,autostart}
		cp ./config/lxqt/*.conf $HOME/.config/lxqt/
		cp ./config/autostart/*.desktop $HOME/.config/autostart/
	fi
	
	# copy my redshift configuration
	if [[ $redshift_config == "yes" ]]; then
		cp ./config/redshift.conf $HOME/.config/
	fi
	
	# create file-manager actions directory
	if [[ $pcmanfmqt_rar == "yes" ]]; then
		mkdir -p $HOME/.local/share/file-manager/actions
		# actions file for extract rar file
		cp ./local/share/file-manager/actions/rar-*.desktop $HOME/.local/share/file-manager/actions/
		echo "Remember to change PCManFM-Qt's Archiver intergration to lxqt-archiver under Preferences > Advanced."
		# actions to open terminal in desktop. Not need for LXQt v1.3
		cp ./local/share/file-manager/actions/open_in_terminal.desktop $HOME/.local/share/file-manager/actions/
	fi
	
	# setup buuf icon theme
	if [[ $theming == "yes" ]]; then
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

  		# installl Nordic theme
    		mkdir -p $HOME/.themes
		wget -P /tmp https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic.tar.xz
		tar -xvf /tmp/Nordic.tar.xz -C $HOME/.themes

  		# add additional geany colorscheme
		mkdir -p $HOME/.config/geany/colorschemes
		git clone https://github.com/geany/geany-themes.git /tmp/geany-themes
		cp -r /tmp/geany-themes/colorschemes/* $HOME/.config/geany/colorschemes/
	fi
	
	# setup my customer bash alias
	if [[ $bashrc == "yes" ]]; then
		echo -e "\nalias temps='watch -n 1 sensors amdgpu-* drivetemp-* k10temp-* asus_wmi_sensors-*'" | tee -a $HOME/.bashrc
		echo "alias syslog='tail -f /var/log/syslog'" | tee -a $HOME/.bashrc
	fi
	
	echo "Remember to logoff and choose the new icon themes from LXQt Apperance Configuration."
}

printf "\n"
printf "Start installation!!!!!!!!!!!\n"
printf "88888888888888888888888888888\n"
printf "Install Extra APps      : $extra_apps\n"
printf "Xorg AMDGPU TearFree    : $amdgpu_tearfree\n"
printf "QEMU KVM		: $qemu\n"
printf "Firefox as DEB packages : $firefox_deb\n"
printf "Custom lm-sensors config: $sensors\n"
printf "Custom LXQt Config      : $lxqt_config\n"
printf "Redshift Config         : $redshift_config\n"
printf "PCmanfm-Qt Rar support  : $pcmanfmqt_rar\n"
printf "Desktop Theming         : $theming\n"
printf "My Bashrc               : $bashrc\n"
printf "88888888888888888888888888888\n"

while true; do
read -p "Do you want to proceed with above settings? (y/n) " yn
	case $yn in
		[yY] ) echo ok, we will proceed; install; echo "Remember to reboot system after the installation!";
			break;;
		[nN] ) echo exiting...;
			exit;;
		* ) echo invalid response;;
	esac
done
