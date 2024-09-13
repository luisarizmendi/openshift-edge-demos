# OpenShift ZTP demo preparation

## Environment & Hardware Requirements

* **OpenShift "Hub" Cluster**: Typically configured with 3 worker nodes, each having 8 cores and 16GB of memory.
* **OpenShift "Edge" Clusters**: At least one additional OpenShift cluster (minimal resources are acceptable).

  > **Note**
  >
  > The "Hub" Cluster is where ACM is deployed. For this demo, it will serve as the "Cloud" cluster.

For the central Hub site, deploying the OpenShift Hub cluster on AWS is recommended due to its ease of setup and scalability. However, OpenShift can also be deployed on other supported environments, including bare-metal servers—though this is not recommended for a demo due to the significant CPU and memory requirements.

For the edge site, the demo can be run on VMs or any `x86_64` server capable of running RHEL (this demo has not been tested with `aarch64`). The server should have at least 8 vCPUs, 16GB of memory, and 120GB of storage. Additionally, the server must have a USB port for booting from an ISO.

The usage of VMs is prefered due to several factors that will be explained below in the "Section-Specific Preparation" section, but if you want to use physical hardware for the edge device, the following equipment is recommended:

- One x86 server for the SNO device (8 CPU cores, 16GB RAM, 100GB+ disk, and one NIC). For Demo Section 2 (GitOps Provisioning with ACM), the server should have a Redfish BMC. If BMC is not available, consider using a VM with a virtual BMC for that section.
- Two USB keys, one with at least 64GB capacity.
- A USB keyboard (a USB RFID mini keyboard is suitable, but avoid Bluetooth-only models).
- A video cable and possibly an HDMI-DisplayPort adapter and an external monitor for boot console display. Alternatively, use a video capture card to view the physical device's video output on your laptop.
- A router capable of configuring PAT rules and/or a VPN.
- A network switch if your router/AP lacks sufficient free interfaces.
- At least three RJ45 cables.
- Depending on your laptop, additional adapters (e.g., RJ45 or HDMI) may be necessary. For example, some venues using HDMI over RJ45 may require specific adapters to ensure proper screen mirroring.









> **IMPORTANT**  
> There is currently an [issue](https://issues.redhat.com/browse/MGMT-18693) with the USB partition table when created with the OpenShift Appliance ISOs (covered in Section 3 of this demo). This issue may prevent your system from booting directly from the USB. If you encounter this problem, consider using the RAW image (for both physical and virtual systems) or deploying the OpenShift Appliance in a VM (mounting with Virtual Media is not affected).














## 1. Base Environment Setup

The base deployment is common to all demos, so refer to the [base environment setup document](../../../bootstrap-environment/doc/bootstrap-environment-steps.md).

## 2. Demo-Specific Environment Setup

There are some configuration steps that, although required, are not the focus of what we want to show during the demo steps, so I decided to provide them pre-configured as part of the demo environment.

To include them in your environment, you have to:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [bootstrap-demo.yaml](../bootstrap-demo/bootstrap-demo.yaml) file.
   - Wait Until All Applications Are in "Sync" Status in the Argo CD Console.

## 3. Section-Specific Preparation

This demo has three different sections. Since you might want to only show some of them, I included the preparation steps separately.

You will find that some of the preparation steps are hard requirements while others are suggested to save time during the demo delivery.

### 1 - Assisted Installer with Advanced Cluster Management

You will need to prepare:
* DNS 
* Network connectivity (VPN or PAT)
* Edge Device

#### Network Connectivity between Edge and Central Site
Red Hat Advanced Cluster Management (ACM) requires access to the device's OpenShift API. You can achieve this by either configuring NAT port forwarding for TCP/6443 to the SNO server or by establishing a VPN between the local network and the environment where ACM is running (e.g., AWS), but I recommend to setup a VPN since you will need it for the next demo section (GitOps Provisioning with Advanced Cluster Management)

If you want to create a VPN and you deployed ACM on AWS, the [`tools` section](../../../tools) includes an [Ansible Playbook](../../../tools/aws_vpn/README.md) to help create a VPN between AWS and your local Linux KVM server/laptop or OpenWRT router.

  > **Note**
  >
  > You can test the VPN by trying to SSH to one OpenShift Node's internal IP address from your Laptop/System.

#### DNS Configuration

You need to configure two entries for each cluster that you want to add:

* `api.<cluster name>.<basedomain>` -> SNO IP
* `*.apps.<cluster name>.<basedomain>` -> SNO IP

  > **Note**
  >
  > If you deployed ACM on AWS you can use Route53 to configure your DNS records

In the example we will name the new cluster for this section as `sno-gui`.

You will need to know the SNO IP to setup the DNS entries. You can setup the IP statically during the node deployment (explained during the demo steps) or you can configure your local DHCP service to provide the IP to know it in advance.


### 2 - GitOps Provisioning with Advanced Cluster Management

You will need to prepare:
* DNS 
* Network connectivity (VPN)
* Edge Device
* Manifests

#### DNS Configuration

You need to configure two entries for each cluster. In the example we will name the new cluster for this section as `sno-gitops`, `sno-1` as hostname and `bmc` as BMC name so if using those values you will need to configure:

* `api.sno-gitops.<basedomain>` -> SNO IP
* `*.apps.sno-gitops.<basedomain>` -> SNO IP
* sno-1.sno-gitops.<basedomain> -> SNO IP
* bmc.sno-gitops.<basedomain> -> BMC IP (or laptop IP if using Sushy tools)


#### Network Connectivity between Edge and Central Site
ACM needs access to both the OpenShift API and the Redfish BMC (default port TCP/8000). Port NAT can be configured for the API, and potentially for the BMC, but this section also requires direct connectivity. The device must download the "Discovery ISO" from one of the OpenShift Hub Cluster nodes' private IPs, which needs a VPN if the edge device is not on the same network as ACM. Remember that if ACM is in AWS, you can use the [provided playbooks to set up the VPN](../../../tools/aws_vpn/README.md).

#### Virtual BMC and OpenShift Single Node VM

If you don't have a physical device with BMC, you can deploy your Edge device (Single Node OpenShift) using a Virtual Machine and manage it with a Virtual BMC service. In the [`tools` section](../../../tools), you can find several scripts that [enable a Virtual BMC in your KVM host](../../../tools/virtual-bmc/README.md)  

If you create the VM using Virtual Machine Manager, select the "Manual Install" method to create a BIOS or UEFI VM with at least the required minimum resources (8vCPU, 16GB memory, 120GB disk, 1 Network). It also need to have a VirtualMedia drive (CDROM).

RRegarding the network, remember that you need to access the VM from outside your Laptop, so it's better to configure a bridge and provide to the VM direct access to the physical network. In the  [`tools` section](../../../tools) you will also find scripts that help [create a network bridge](../../../tools/libvirt-bridge/README.md) in your Linux system that you can attach to the SNO VM. The script will create a bridged network named `ocp-br` that you can select while creating the VM.

Turn off the VM after creating it and take note of the VM UUID (in Virtual Machine Manager you will find it in "Overview").

  > **Note**
  >
  > You can run the [virtual BMC test ](../../../tools/virtual-bmc/test-redfish.sh) to show all the VM ID and check if the new VM UUID appears there

#### Manifest preparation

As part of the [base environment preparation](../../../bootstrap-environment/doc/bootstrap-environment-steps.md) you will have your own Git repository (where you have full access) so you should be able to make changes in the GitOps manifests. 

As part of this demo section you will need to prepare 



* [SiteConfig manifest](../demo-manifests/01-gitops/resources/siteconfig/demo-gitops.yaml) 
  
  In this file you need to modify:

  - `baseDomain`: Including your DNS domain
  - `sshPublicKey`: With your public SSH key
  - `machineNetwork`: This is the network CIDR that will be attached to the SNO
  - `hostName`: You can just change the domain.
  - `bmcAddress`: This address is prepared to interact with the virtual BMC (Sushy tools), if you are using a physical BMC you might need to change the URI. Be sure that they dns name is correct (including the domain) and that the ID points to your VM's UUID.
  - `bootMACAddress` and `macAddress`: 
  - `bootMode`
  - `ip`
  - `next-hop-address`


`installConfigOverrides`



in demo-gitops change:
 - mac address
 - url vmc (including ip, port and vm id if sushy)
 - ip addressing (machineNetwork)
 - be sure about dns






* [Pull Secret](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml.example) 

  Take this example file, include [your pull-secret](https://access.redhat.com/solutions/4844461) and remove the `.example` extension 


* [BMC user and password](../demo-manifests/01-gitops/02-gitops-bmc-secret.yaml.example) 

  Even if you are using the virtual BMC where there is no user or password, you will need to configure this secret, so if you are not using a physical BMC with an actual real user/password, just remove the `.example` extension of this example file.

Remember to push your changes to your repo after making changes but double check that you are not exposing publically your pull-secret.


### 3 - OpenShift Appliance

#### Base and Config Images Creation
To save time (around one hour), it's recommended to create the OpenShift Appliance Base and configuration Images beforehand. To make this process easier, you will find in the [`tools` section](../../../tools) some [Ansible Playbooks to create the OpenShift Appliance Assets](../../../tools/ocp-appliance/README.md). These playbooks not only help in creating the default images but also allow easy inclusion of custom manifests and container images into the images.

I also recommend creating the associated USB keys with those images if you plan to use physical hardware as a preparation step.

#### Single Node OpenShift Virtual Machine
You can also use the script for [creating the SNO Virtual Machine](../../../tools/libvirt-sno/README.md) and the associated resources in KVM if you need to deploy the OpenShift Appliance in a Virtual Machine.

#### DNS Configuration

You need to configure two entries for each cluster that you want to add:

* `api.<cluster name>.<basedomain>`
* `*.apps.<cluster name>.<basedomain>`

  > **Note**
  >
  > If you deployed ACM on AWS you can use Route53 to configure your DNS records

In the example we will name the new cluster for this section as `ocp-appliance`.
