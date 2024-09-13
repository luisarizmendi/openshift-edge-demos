# SNO VM in Libvirt

These scripts helps creating a virtual machine for Single Node OpenShift on top of libvirt in Fedora (tested with Fedora 40) and the associated Host network configuration to permit direct external connectivity to the VM.

The `create-sno-vm.sh` script will:

* Create a bridge interface (`net-sno-br.xml`)
* Create and configure the libvirt storage pool
* Define and start the network (`net-sno.xml`)
* Create the VM disk if it doesn't exist
* Create the SNO VM (`vm-sno.xml`)


## Usage

### Creating the VM and network resources

1. Open the `create-sno-vm.sh` and check that the environment variables are OK for you. You probably want to change the `BRIDGE_IF` that is the physical interface that will be used for the bridge interface. Please bear in mind that you cannot use Wireless interface for the bridge, since you won't be able to have multiple different IPs attached to a single Wireless connection.

2. Run the `create-sno-vm.sh`. If you find issues with SELinux you might need to run these commands:

```bash
sudo ausearch -c 'dnsmasq' --raw | audit2allow -M my-dnsmasq
sudo semodule -X 300 -i my-dnsmasq.pp

sudo ausearch -c 'rpc-virtnetwork' --raw | audit2allow -M my-rpcvirtnetwork
sudo semodule -X 300 -i my-rpcvirtnetwork.pp

sudo ausearch -c 'rpc-virtqemud' --raw | audit2allow -M my-rpcvirtqemud
sudo semodule -X 300 -i my-rpcvirtqemud.pp

sudo ausearch -c 'prio-rpc-virtqe' --raw | audit2allow -M my-priorpcvirtqe
sudo semodule -X 300 -i my-priorpcvirtqe.pp
```

3. Check network connection after the script finish


That's all. Remember that if you want to access the SNO VM from outside your local network you will need to configure your router to forward port 6443, 443 and 80 to the VM.


### Deleting the VM and network resources

1. Run the `deletesno-vm.sh`. The script will also delete the bridge interface (deletes using `nmcli` looking for the same name than interface).

