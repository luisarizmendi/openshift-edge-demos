#!/bin/bash

BRIDGE_IF="enp58s0u1u2"

VM_NAME="sno"
NETWORK_NAME="sno"
BRIDGE_NAME="sno-br"
DISK_PATH="/var/lib/libvirt/images/sno.qcow2"


check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Step 1: Stop and undefine the VM
echo "Stopping and undefining the VM: $VM_NAME"
sudo virsh dominfo $VM_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # VM exists, attempt to destroy and undefine it
    if [ $(sudo virsh dominfo $VM_NAME | grep 'State:' | awk '{print $2}') == "running" ]; then
        echo "VM $VM_NAME is running. Attempting to destroy it..."
        sudo virsh destroy $VM_NAME
        check_command "virsh destroy"
    else
        echo "VM $VM_NAME is not running"
    fi

    sudo virsh undefine $VM_NAME
    check_command "virsh undefine"
else
    echo "VM $VM_NAME does not exist."
fi

if [ -f "$DISK_PATH" ]; then
    echo "Disk file $DISK_PATH exists. Deleting it..."
    sudo rm -f "$DISK_PATH"
    check_command "rm -f $DISK_PATH"
else
    echo "Disk file $DISK_PATH does not exist."
fi

# Step 2: Destroy and undefine the network


for i in $(nmcli con show | grep $BRIDGE_IF | awk '{print $2}'); do nmcli con delete $i;done
for i in $(nmcli con show | grep $BRIDGE_NAME | awk '{print $2}'); do nmcli con delete $i;done
sudo nmcli con delete virbr99
sudo nmcli con add type ethernet con-name $BRIDGE_IF ifname $BRIDGE_IF ipv4.method auto ipv6.method auto autoconnect yes


echo "Destroying and undefining the network: $NETWORK_NAME"
sudo virsh net-info $NETWORK_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # Network exists, attempt to destroy and undefine it
    sudo virsh net-destroy $NETWORK_NAME

    sudo virsh net-undefine $NETWORK_NAME
    check_command "virsh net-undefine"
else
    echo "Network $NETWORK_NAME does not exist."
fi

sudo virsh net-info $BRIDGE_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # Network exists, attempt to destroy and undefine it
    sudo virsh net-destroy $BRIDGE_NAME

    sudo virsh net-undefine $BRIDGE_NAME
    check_command "virsh net-undefine"
else
    echo "Network $BRIDGE_NAME does not exist."
fi


echo "Cleanup completed successfully."
