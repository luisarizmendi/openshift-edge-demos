#!/bin/bash

POOL_NAME="default"
POOL_PATH="/var/lib/libvirt/sno-ztp"
NETWORK_XML_PATH="net.xml" 
VM_XML_PATH="vm.xml"       
DISK_PATH="/var/lib/libvirt/images/sno-ztp.qcow2"
DISK_SIZE="200G"

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Step 1: Create and configure the storage pool
echo "Creating storage pool..."
mkdir -p $POOL_PATH
check_command "mkdir"

virsh pool-define-as $POOL_NAME --type dir --target $POOL_PATH
check_command "virsh pool-define-as"

virsh pool-start $POOL_NAME
check_command "virsh pool-start"

virsh pool-autostart $POOL_NAME
check_command "virsh pool-autostart"

# Step 2: Define and start the network
echo "Defining and starting the network..."
virsh net-define $NETWORK_XML_PATH
check_command "virsh net-define"

virsh net-start sno
check_command "virsh net-start"

virsh net-autostart sno
check_command "virsh net-autostart"

# Step 3: Create the disk
echo "Creating the disk..."
qemu-img create -f qcow2 $DISK_PATH $DISK_SIZE
check_command "qemu-img create"

# Step 4: Define the VM
echo "Defining the VM..."
virsh define $VM_XML_PATH
check_command "virsh define"

virsh autostart sno
check_command "virsh autostart"

echo "Setup completed successfully."
