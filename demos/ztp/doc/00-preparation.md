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


### 

There are some configuration steps that, although required, are not the focus of what we want to show during the demo steps, so I decided to provide them pre-configured as part of the demo environment.

To include them in your environment, you have to:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [bootstrap-demo.yaml](../bootstrap-demo/bootstrap-demo.yaml) file.
   - Wait Until All Applications Are in "Sync" Status in the Argo CD Console.




### DNS


### VM








sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 192.168.100.0/24 -d 10.0.0.0/8 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 1 -s 192.168.100.0/24 -j MASQUERADE
sudo firewall-cmd --reload




















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

#### Prerequisites

To begin, ensure the following are ready:

- **DNS configuration**
- **Network connectivity** (via VPN, if needed)
- **Edge Device setup**
- **Manifests** for deployment

#### DNS Configuration

You must configure two DNS entries for each cluster. For this example, the new cluster is named `sno-gitops`, with `sno-1` as the hostname and `bmc` as the BMC name. Using these values, configure the following DNS records:

- `api.sno-gitops.<basedomain>` -> SNO IP
- `*.apps.sno-gitops.<basedomain>` -> SNO IP
- `sno-1.sno-gitops.<basedomain>` -> SNO IP
- `bmc.sno-gitops.<basedomain>` -> BMC IP (or laptop IP if using Sushy tools)

#### Network Connectivity

For Advanced Cluster Management (ACM), ensure access to both the OpenShift API and the Redfish BMC (default port TCP/8000). Port NAT can be configured for API and BMC access, but direct connectivity is often required. The edge device needs to download the "Discovery ISO" from one of the OpenShift Hub Cluster nodes' private IPs. If the edge device is on a different network than ACM, a VPN is necessary. 

If ACM is hosted on AWS, you can utilize the [AWS VPN setup playbooks](../../../tools/aws_vpn/README.md) to configure connectivity.

#### Virtual BMC and Single Node OpenShift VM

For users without a physical BMC-enabled device, a Single Node OpenShift (SNO) edge device can be deployed via a Virtual Machine (VM) and managed using a Virtual BMC service. 

To create a VM in Virtual Machine Manager, follow the "Manual Install" process, ensuring the VM has:

- **8 vCPU**, **16GB RAM**, **120GB storage**, and at least one network interface.
- A **VirtualMedia drive** (CD-ROM).
- Network allowed to access external networks (ie. DNS server)

> **NOTE**  
> Remember that in order to configure your machine to use UEFI boot (recommended) with Virtual Machine Manager, you need to select "Customize before lauch" while creating the VM

After setting up the VM, power it off and note the VM UUID, which can be found under the "Overview" section of Virtual Machine Manager.

> **Tip**  
> Run the [Virtual BMC test](../../../tools/virtual-bmc/test-redfish.sh) to confirm the VM UUID appears in the test output.

#### Manifest Preparation

With the base environment set up, access your Git repository, where you'll modify the GitOps manifests for deployment. Specifically, you need to prepare the following manifests:

1. **SiteConfig Manifest**:  
   Update the [demo-gitops.yaml](../demo-manifests/01-gitops/resources/siteconfig/demo-gitops.yaml) file with the following changes:
   - `baseDomain`: Your DNS domain.
   - `sshPublicKey`: Add your public SSH key.
   - `machineNetwork`: Set the network CIDR for SNO.
   - `hostName`: Adjust the domain name as necessary.
   - `bmcAddress`: Ensure this points to the correct virtual or physical BMC IP. Verify that the DNS entry is correct and that the VM UUID is referenced.
   - `bootMACAddress`: MAC address of the VM's network interface.
   - `bootMode`: Match with the device's boot mode.

   Optionally, you may:
   - **Reduce Hardware Footprint**: To minimize the resource requirements of SNO, include the `installConfigOverrides` section (although you’ll still need at least 8 vCPU and 16GB RAM).
   - **Configure Static IP**: Add static IP settings under the `nodeNetwork` section.

2. **Pull Secret**:  
   Use the example [pull-secret.yaml file](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml.example), add your Red Hat [pull secret](https://access.redhat.com/solutions/4844461), and rename the file by removing the `.example` extension.

3. **BMC Credentials**:  
   Even if using a virtual BMC where you didn't configure any real credentials, you have to configure the [BMC secret](../demo-manifests/01-gitops/02-gitops-bmc-secret.yaml.example) by renaming the file and removing the `.example` extension.

After editing the manifests, push the changes to your Git repository. Before pushing, verify that you do not accidentally expose sensitive information, such as your pull-secret.

### 3 - OpenShift Appliance

#### Base and Config Images Creation
To save time (around one hour), it's recommended to create the OpenShift Appliance Base and configuration Images beforehand. To make this process easier, you will find in the [`tools` section](../../../tools) some [Ansible Playbooks to create the OpenShift Appliance Assets](../../../tools/ocp-appliance/README.md). These playbooks not only help in creating the default images but also allow easy inclusion of custom manifests and container images into the images.

I also recommend creating the associated USB keys with those images if you plan to use physical hardware as a preparation step.

#### Single Node OpenShift Virtual Machine
You can also use the script for [creating the SNO Virtual Machine](../../../tools/libvirt-sno/README.md) and the associated resources in KVM if you need to deploy the OpenShift Appliance in a Virtual Machine.






xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



















#### DNS Configuration

You need to configure two entries for each cluster that you want to add:

* `api.<cluster name>.<basedomain>`
* `*.apps.<cluster name>.<basedomain>`

  > **Note**
  >
  > If you deployed ACM on AWS you can use Route53 to configure your DNS records

In the example we will name the new cluster for this section as `ocp-appliance`.
