#!/usr/bin/env bash
 
## Define variables
MEM_SIZE=2048    # Mem size definied in MB
VCPUS=1
VM_NAME="CentOS-7"
DISK_SIZE="10"   # Disk size defined in GB
#HOME="$(echo "$HOME")"
ISO_IMG=""$HOME"/Downloads/CentOS-7-x86_64-Minimal-2009.iso"
 
virt-install \
     --name ${VM_NAME} \
     --memory=${MEM_SIZE} \
     --vcpus=${VCPUS} \
     --location ${ISO_IMG} \
     --disk size=${DISK_SIZE}  \
     --network bridge=virbr0 \
     --graphics=none \
     --console pty,target_type=serial \
     --initrd-inject "$HOME"/kickstart/templates/default.cfg --extra-args "inst.ks=file:default.cfg console=tty0 console=ttyS0,115200n8"
