# OpenShift ZTP demo preparation

## 0. Environment & Hardware Requirements

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

---

## 1. Base Environment Setup

The base deployment is common to all demos, so refer to the [base environment setup document](../../../bootstrap-environment/doc/bootstrap-environment-steps.md).

---

## 2. Demo-Specific Environment Setup

### Demo bootstrap in ArgoCD

There are some configuration steps that, although required, are not the focus of what we want to show during the demo steps, so I decided to provide them pre-configured as part of the demo environment.

To include them in your environment, you have to:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [bootstrap-demo.yaml](../bootstrap-demo/bootstrap-demo.yaml) file.
   - Wait Until All Applications Are in "Sync" Status in the Argo CD Console.


### DNS Configuration

You must configure two DNS entries for each cluster. You will create three different SNOs, if you use the name examples given during the demo steps you will need to create the following DNS records:

- `api.sno-gui.<basedomain>` -> SNO-1 IP
- `*.apps.sno-gui.<basedomain>` -> SNO-1 IP

- `api.sno-gitops.<basedomain>` -> SNO-2 IP
- `*.apps.sno-gitops.<basedomain>` -> SNO-2 IP

- `api.ocp-appliance.<basedomain>` -> SNO-3 IP
- `*.apps.ocp-appliance.<basedomain>` -> SNO-3 IP

If you don't change the example Redfish URL used in Section 3, you will need to create an additional entry:

- `bmc.sno-gitops.<basedomain>` -> BMC IP (laptop IP if using Sushy tools)


### Network Connectivity between OpenShift Hub cluster and edge SNO
The requirements are different depending on the Demo Sections that you want to run:

#### Section 1 - Assisted Installer with Advanced Cluster Management
Red Hat Advanced Cluster Management (ACM) requires access to the device's OpenShift API. You can achieve this by either configuring NAT port forwarding for TCP/6443 to the SNO server. You can also create a VPN since it is required for Section 2.

#### Section 2 - GitOps Provisioning with Advanced Cluster Management
For Advanced Cluster Management (ACM), ensure access to both the OpenShift API and the Redfish BMC (default port TCP/8000). Port NAT can be configured for API and BMC access, but direct connectivity is required to download the discovery ISO from one Hub Cluster node's private IP, so you will need to setup a VPN if the OpenShift Hub cluster has no direct access to the SNO network.

If ACM is hosted on AWS, you can utilize the [AWS VPN setup playbooks](../../../tools/aws_vpn/README.md) to configure connectivity.

  > **Note**
  > You can test the VPN by trying to SSH to one OpenShift Node's internal IP address from your Laptop/System.

#### Section 3 - OpenShift Appliance
There is no special requirements. OpenShift Appliance can be used even in completely disconnected environments.


### Edge Device VM
If using Virtual Machines, you will need to create at least three, one per Section. If you are using  Virtual Machine Manager, you will need to select  the "Manual Install" process, ensuring the VM has:


- **8 vCPU**, **16GB RAM**, **120GB storage**, and at least one network interface.
- A **VirtualMedia drive** (CD-ROM).
- Network allowed to access external networks (ie. DNS server)

> **NOTE**  
> Remember that in order to configure your machine to use UEFI boot (recommended) with Virtual Machine Manager, you need to select "Customize before lauch" while creating the VM

Section 2 needs access to a BMC. For users without a physical BMC-enabled device, a Single Node OpenShift (SNO) edge device can be deployed via a Virtual Machine (VM) and managed using a Virtual Redfish BMC service ([Sushy tools](https://docs.openstack.org/sushy-tools/latest/user/dynamic-emulator.html)). In the [`tools` section](../../../tools) you will find several simple scripts that help setting this up. 

> **Tip**  
> Remeber that for the Section 2, you will need the VM UUID (it is included in the virtual Redfish URI). You can run a [virtual BMC test](../../../tools/virtual-bmc/test-redfish.sh) to confirm the VM UUID appears in the test output.

One important point is the Virtual Machine connectivity. If you plan to run the demo Section 2 you need to setup a VPN, and your VM must use that connection without changing its source IP (so without NAT), and at the same time it needs to reach out to external Internet resources. There are several virtual network setups that you can configure but probably the simpliest one is to create a "Routed Network" and configure manually NAT when the VM traffic goes to Internet, while keeping the original source IP when going through the VPN. If you created the VPN with the scripts provided, you can configure the VM network by running the following commands after creating the virtual routed network:  

```bash
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s <CIDR routed network> -d 10.0.0.0/8 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 1 -s <CIDR routed network> -j MASQUERADE
sudo firewall-cmd --reload
```

> **Tip**  
> Create an additional test VM in that new network and check that you can connect to services in Internet while your source IP is not changed when connecting to the Cloud using the VPN.

---

## 3. Section-Specific Preparation

This demo has three different sections. Since you might want to only show some of them, I included the preparation steps separately.

You will find that some of the preparation steps are hard requirements while others are suggested to save time during the demo delivery.

### 1 - Assisted Installer with Advanced Cluster Management

If you plan to use physical Hardware you need to bear in mind that currently, in order to create a bootable USB with the generated Discovery ISO, you will need to change the default from "minimal ISO" to "full ISO" otherwise the server won't start (minimal works with virtual media only at this moment).

If you need to do it, you must change the [`04-demo-gitops-agentserviceconfig.yaml`](../bootstrap-demo/resources/base/04-demo-gitops-agentserviceconfig.yaml) file, adding the `unsupported.agent-install` annotation:


```yaml
apiVersion: agent-install.openshift.io/v1beta1
kind: AgentServiceConfig
metadata:
 name: agent
 annotations:
   argocd.argoproj.io/sync-wave: "4"
   argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
   unsupported.agent-install.openshift.io/assisted-service-configmap: full-iso-config
spec:
  databaseStorage:
...
```

It's also a good idea to prepare the following manifests with your data, so during the demo you just need to copy/paste:

* [sno-1-network.yaml](../demo-manifests/00-gui/sno-1-network.yaml)


### 2 - GitOps Provisioning with Advanced Cluster Management

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
To save time (around one hour), it's recommended to create the OpenShift Appliance Base and configuration Images beforehand. To make this process easier, you will find in the [`tools` section](../../../tools) some [Ansible Playbooks to create the OpenShift Appliance Assets](../../../tools/ocp-appliance/README.md). These playbooks not only help in creating the default images but also allow easy inclusion of custom manifests and container images into the images.

I also recommend creating the associated USB keys with those images if you plan to use physical hardware as a preparation step.




