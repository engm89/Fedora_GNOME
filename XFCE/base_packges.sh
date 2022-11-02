#!/bin/bash
#
# Check if the current user os root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

#Edit DNF Repo settings
# copy config files to /etc

echo -e "\nCopying config files ..."
rm /etc/dnf/dnf.conf
if [[ -d configs ]]; then
  cp -ri configs/. /etc
else
  echo -e "\nDirectory not found."
fi

#Add RPM Fusion Repo
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y


# Update the system and packages
dnf update -y
dnf upgrade -y

# Base Packages
if ! dnf install --assumeyes @base-x xfce4-panel xfce4-datetime-plugin xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop  xfce4-appfinder xfce4-power-manager xfce4-pulseaudio-plugin pulseaudio gvfs lightdm-gtk xfwm4 NetworkManager-wifi pciutils @development-tools ffmpegthumbnailer file-roller  htop dnf-plugins-core -y

then
    echo "Error while installing packages."
    exit
fi


# Install fedy copr repository
dnf copr enable kwizart/fedy -y

# Install fedy
dnf install fedy -y

# set Hostname

hostnamectl set-hostname Fedora


# Setup complete.  reboot system now or not
read -p "Setup of this system is complete. Reboot is recommended. Would you like to do this now? " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy] ]]
	then
    
		echo "Rebooting in 5 seconds"
		sleep 5
		sudo reboot now
	else
		echo "Exiting Setup"
		sleep 1
fi

exit
