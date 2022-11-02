#Gnome Shell Tweaks
#adding all buttons - minimize,maximize,close
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
#show seconds
gsettings set org.gnome.desktop.interface clock-show-seconds true
#show date
gsettings set org.gnome.desktop.interface clock-show-date true
#show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true
# Power button do Nothing
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'nothing'

# Power Saver
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery true

# Sleeping settings
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 900
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
