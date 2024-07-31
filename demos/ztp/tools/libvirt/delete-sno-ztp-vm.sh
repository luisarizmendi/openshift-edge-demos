#!/bin/bash

#!/bin/bash

# Define variables
VM_NAME="sno-ztp"
NETWORK_NAME="sno-ztp"
DISK_PATH="/var/lib/libvirt/images/sno-ztp.qcow2"

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
echo "Destroying and undefining the network: $NETWORK_NAME"
sudo virsh net-info $NETWORK_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # Network exists, attempt to destroy and undefine it
    sudo virsh net-destroy $NETWORK_NAME
    check_command "virsh net-destroy"

    sudo virsh net-undefine $NETWORK_NAME
    check_command "virsh net-undefine"
else
    echo "Network $NETWORK_NAME does not exist."
fi

sudo nmcli con delete sno-ztp-br

echo "Cleanup completed successfully."
