# This installation script has been written for Rocky9 minimal install
# and might not work with different versions of RedHat/ CentOS/ Rocky. 

#!/bin/bash

# Installing kvm + libvirt
yum update -y
yum install -y qemu-kvm libvirt libguestfs-tools virt-install

# Adding the user to relative groups
groupmod -a -U $(whoami) kvm
groupmod -a -U $(whoami) qemu
groupmod -a -U $(whoami) libvirt

# Defaulting virsh to libvirt admin session
echo 'LIBVIRT_DEFAULT_URI="qemu:///system"' >> /etc/environment

# Enabling ipv4 traffic forwarding
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

# Sorting libvirt user permissions
echo -e 'uri_default = "qemu:///system"\nunix_sock_group = "libvirt"\nunix_sock_ro_perms = "0777"\nunix_sock_rw_perms = "0770"' >> /etc/libvirt/libvirt.conf

# Allowing the user "qemu" RX to the user's home folder
# This may not be needed if storing the iso outside of /home
setfacl -m u:qemu:rx /home/$(whoami)

# Loading libvirt default network config
export LIBVIRT_DEFAULT_URI="qemu:///system"
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-autostart default

# Enabling libvirt systemd service
systemctl enable libvirtd

# See you later!
reboot
