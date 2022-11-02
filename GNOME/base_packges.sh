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
rm /etc/nanorc
rm /etc/vimrc
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
echo -e "\nInstalling Base Packages ..."
if ! dnf install --assumeyes @base-x gnome-shell gnome-terminal nautilus nautilus-open-terminal dconf-editor chrome-gnome-shell gnome-tweaks gdm pciutils @development-tools ffmpegthumbnailer gnome-calculator gnome-system-monitor gedit evince file-roller gnome-extensions-app htop dnf-plugins-core -y

then
    echo "Error while installing packages."
    exit
fi
echo -e "\nBase Packages installation completed"

# Install fedy copr repository
dnf copr enable kwizart/fedy -y

# Install fedy
dnf install fedy -y

echo -e "\nFedy configured and installed"

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
