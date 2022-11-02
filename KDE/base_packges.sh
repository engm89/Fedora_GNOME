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
if ! dnf install --assumeyes @base-x pciutils @development-tools ffmpegthumbnailer file-roller  htop dnf-plugins-core NetworkManager-config-connectivity-fedora adwaita-gtk2-theme bluedevil breeze-icon-theme cagibi colord-kde cups-pk-helper dolphin firewall-config glibc-all-langpacks gnome-keyring-pam kcm_systemd kde-gtk-config kde-partitionmanager kde-platform-plugin kde-print-manager kde-runtime kde-settings-pulseaudio kde-style-breeze kdegraphics-thumbnailers kdelibs kdeplasma-addons kdialog kf5-akonadi-server kf5-akonadi-server-mysql kf5-baloo-file kf5-kipi-plugins kfind kgpg khotkeys kinfocenter kmenuedit konsole5 kscreen kscreenlocker ksshaskpass ksysguard kwebkitpart kwin phonon-backend-gstreamer phonon-qt5-backend-gstreamer pinentry-qt plasma-breeze plasma-desktop plasma-desktop-doc plasma-drkonqi plasma-nm plasma-nm-l2tp plasma-nm-openswan plasma-nm-pptp plasma-pa plasma-pk-updates plasma-user-manager plasma-workspace plasma-workspace-geolocation polkit-kde qt5-qtbase-gui qt5-qtdeclarative sddm sddm-breeze sddm-kcm sni-qt xorg-x11-drv-libinput setroubleshoot  system-config-language -y

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
