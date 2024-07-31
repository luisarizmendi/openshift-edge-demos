#!/bin/bash

POOL_NAME="default"
POOL_PATH="/var/lib/libvirt/images"
NETWORK_XML_PATH_BASE="net" 
VM_XML_PATH_BASE="vm"       
DISK_PATH="/var/lib/libvirt/images/sno-ztp.qcow2"
DISK_SIZE="200G"
VM_NAME="sno-ztp"
NETWORK_NAME="sno-ztp"
BRIDGE_NAME="sno-ztp-br"
BRIDGE_IF="enp58s0u1u2"

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Step 0: Enable libvirt services in Fedora
echo "Enabling daemon libvirt services..."
sudo systemctl start virtlogd
sudo systemctl enable virtlogd

sudo systemctl start virtnetworkd
sudo systemctl enable virtnetworkd


# Step 1: Create and configure the storage pool
echo "Checking for an existing storage pool..."
EXISTING_POOL_PATH=$(virsh pool-dumpxml $POOL_NAME 2>/dev/null | grep -oP '(?<=<path>)[^<]+')

if [ -n "$EXISTING_POOL_PATH" ]; then
    echo "Existing storage pool found at: $EXISTING_POOL_PATH"
    POOL_PATH=$EXISTING_POOL_PATH
else
    echo "No existing storage pool found. Creating a new one at $POOL_PATH..."
    sudo mkdir -p $POOL_PATH
    check_command "mkdir"
    
    sudo virsh pool-define-as $POOL_NAME --type dir --target $POOL_PATH
    check_command "virsh pool-define-as"
    
    sudo virsh pool-start $POOL_NAME
    check_command "virsh pool-start"
    
    sudo virsh pool-autostart $POOL_NAME
    check_command "virsh pool-autostart"
fi 

# Step 2: Define and start the network
if $(sudo virsh net-list --all | grep -q "$NETWORK_NAME"); then
    echo "Network $NETWORK_NAME already exists. Skipping network creation."
else
    echo "Defining and starting the network..."
    sudo virsh net-define ${NETWORK_XML_PATH_BASE}-${NETWORK_NAME}.xml
    check_command "virsh net-define"
    
    sudo virsh net-start $NETWORK_NAME
    check_command "virsh net-start"
    
    sudo virsh net-autostart $NETWORK_NAME
    check_command "virsh net-autostart"

    sudo virsh net-define ${NETWORK_XML_PATH_BASE}-${BRIDGE_NAME}.xml
    check_command "virsh net-define"
    
    sudo virsh net-start $BRIDGE_NAME
    check_command "virsh net-start"
    
    sudo virsh net-autostart $BRIDGE_NAME
    check_command "virsh net-autostart"


fi

# Install bridge-utils if not already installed
#sudo dnf install bridge-utils

# Create a bridge interface 
sudo nmcli con delete $BRIDGE_IF 
sudo nmcli con add type bridge ifname $BRIDGE_NAME con-name $BRIDGE_NAME autoconnect yes
sudo nmcli con add type bridge-slave ifname $BRIDGE_IF master $BRIDGE_NAME autoconnect yes
sudo nmcli connection modify $BRIDGE_NAME bridge.stp no
sudo nmcli con up $BRIDGE_NAME


# Step 3: Create the disk if it doesn't exist
if [ -f "$DISK_PATH" ]; then
    echo "Disk $DISK_PATH already exists. Skipping creation."
else
    echo "Creating the disk at $DISK_PATH..."
    sudo qemu-img create -f qcow2 $DISK_PATH $DISK_SIZE
    check_command "qemu-img create"
fi

# Step 4: Define the VM
echo "Defining the VM..."
sudo virsh define ${VM_XML_PATH_BASE}-${VM_NAME}.xml
check_command "virsh define"

sudo virsh autostart $VM_NAME
check_command "virsh autostart"

echo "Setup completed successfully."