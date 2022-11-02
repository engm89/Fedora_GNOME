#!/bin/bash
#
# Check if the current user os root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

read -p "Enter the Fedora version for downloading Backgrounds: " f_Var

# Add docker and Vscode repo
dnf config-manager  --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

# install additional packages
echo -e "\nInstall additional packages."
dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin vlc code libreoffice vim bash-completion firefox gconf-editor -y

# Backgrouds
echo -e "\nInstall Fedora backgrounds."

dnf install f$f_Var-backgrounds-gnome f$f_Var-backgrounds-extras-gnome -y

#dnf install ../rpms/*.rpm


# Enable and Disable some Services
systemctl set-default graphical.target
systemctl disable cups NetworkManager-wait-online.service
sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config
setenforce 0
systemctl start docker


# add users to docker group

usermod -aG docker $USER

# Nvidia
nvidia_check=$(/sbin/lspci | grep -i '.* vga .* nvidia .*')

shopt -s nocasematch

##echo -e "${b}Making tweaks to Gnome Shell${n}\n"
#gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

echo "Install Virtualization"
read -p "Do you want to install Linux KVM native virtualization? [yn] " answer
if [[ $answer = y ]]; then

bash ./virtualization.sh
elif [[ $answer = n ]]; then
  echo "Install your favorite Virtualization software through its supported method"
fi


if [[ $nvidia_check == *' nvidia '* ]]; then
  printf 'NVIDIA GPU is present:  %s\n' "$nvidia_check"
  read -p "Would you like to install the proprietary NVIDIA Drivers? (Yes/No) " choice
	if [[ "$choice" =~ ^[Yy] ]]
	then
		echo "Okay, installing NVIDIA drivers."
		sudo dnf install akmod-nvidia -y && sudo dnf install xorg-x11-drv-nvidia-cuda
	else
		echo "Okay, Not installing NVIDIA drivers.
		"
	fi
	else
  	echo "NVIDIA GPU is not present."
fi

# Setup complete.  reboot system now or not
read -p "Setup of this system is complete. Reboot is recommended. Would you like to do this now? " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy] ]]
	then
		rm -rf ~/Fedora_Installation
		echo "Rebooting in 5 seconds"
		sleep 5
		sudo reboot now
	else
		echo "Exiting Setup"
		sleep 1
fi

exit
