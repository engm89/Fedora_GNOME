
sudo dnf -y groupinstall with-optional virtualization

# allowing administration by me
echo 'unix_sock_group = "libvirt"' | sudo tee /etc/libvirt/libvirtd.conf
echo 'unix_sock_rw_perms = "0770"' | sudo tee /etc/libvirt/libvirtd.conf

sudo systemctl enable --now libvirtd

sudo usermod -a -G libvirt $(whoami)
