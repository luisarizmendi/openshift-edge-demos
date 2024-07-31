#!/bin/bash

#!/bin/bash

# Define variables
VM_NAME="sno-ztp"
NETWORK_NAME="sno-ztp"

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Step 1: Stop and undefine the VM
echo "Stopping and undefining the VM: $VM_NAME"
virsh dominfo $VM_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # VM exists, attempt to destroy and undefine it
    virsh destroy $VM_NAME
    check_command "virsh destroy"

    virsh undefine $VM_NAME
    check_command "virsh undefine"
else
    echo "VM $VM_NAME does not exist."
fi

# Step 2: Destroy and undefine the network
echo "Destroying and undefining the network: $NETWORK_NAME"
virsh net-info $NETWORK_NAME &> /dev/null
if [ $? -eq 0 ]; then
    # Network exists, attempt to destroy and undefine it
    virsh net-destroy $NETWORK_NAME
    check_command "virsh net-destroy"

    virsh net-undefine $NETWORK_NAME
    check_command "virsh net-undefine"
else
    echo "Network $NETWORK_NAME does not exist."
fi

echo "Cleanup completed successfully."
