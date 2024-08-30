# Virtual BMC with Sushy tools

In case that you need a device that has Baseboard Management Controller (BMC) for out-of-band management using [Redfish](https://www.dmtf.org/standards/redfish) (ie. ACM deploying baremetal OpenShift) and you don't have such Hardware, you can use [Sushy tool](https://docs.openstack.org/sushy/latest/) to emulate a physical BMC. 

You can use that emulated BMC to manage VMs running with `libvirt` in your system.

These shell scripts help deploying and using Sushy.

## Prerequisites

You will need `libvirt` installed since the VMs that Sushy controls need to be running in that hypervisor.

The script starts a Sushy container using `podman`, so you need it in your system.

Sushy uses by default the port `TCP/8000` that you will need to permit that port in your firewall.

## Using Sushy tools

### Start Virtual BMC

If you are using a local `libvirt` and defaults are ok for you, just run:

```bash
./start-redfish.sh
```

If you need to connect to an external `libvirt` you will first need to configure the `sushy-tools/sushy-emulator.conf` file.


### Testing/Usage

```bash
./test-redfish.sh
```

The script will list all the VMs running in your libvirt, but you can also try to start a VM using the virtual Redfish BMC: (change the ID in the `curl` command by your VM's ID)

```bash
curl -d '{"ResetType":"On"}' -H "Content-Type: application/json" -X POST http://localhost:8000/redfish/v1/Systems/<VM ID>/Actions/ComputerSystem.Reset
```

...or power it off:

```bash
curl -d '{"ResetType":"ForceOff"}' -H "Content-Type: application/json" -X POST http://localhost:8000/redfish/v1/Systems/<VM ID>/Actions/ComputerSystem.Reset
```


or insert a virtualcd:

```bash
curl -d '{"Image": "https://download.cirros-cloud.net/0.6.2/cirros-0.6.2-aarch64-disk.img", "Inserted": true}'      -H "Content-Type: application/json"      -X POST      http://localhost:8000/redfish/v1/Systems/<VM ID>/VirtualMedia/Cd/Actions/VirtualMedia.InsertMedia
```


### Stop Virtual BMC

```bash
./stop-redfish.sh
```


