# OpenShift ZTP demo preparation

## Environment & Hardware Requirements

* **OpenShift "Hub" Cluster**: Typically configured with 3 worker nodes, each having 8 cores and 16GB of memory.
* **OpenShift "Edge" Clusters**: At least one additional OpenShift cluster (minimal resources are acceptable).

  > **Note**
  >
  > The "Hub" Cluster is where ACM is deployed. For this demo, it will serve as the "Cloud" cluster.

For the central Hub site, deploying the OpenShift Hub cluster on AWS is recommended due to its ease of setup and scalability. However, OpenShift can also be deployed on other supported environments, including bare-metal servers—though this is not recommended for a demo due to the significant CPU and memory requirements.

For the edge site, the demo can be run on VMs or any `x86_64` server capable of running RHEL (this demo has not been tested with `aarch64`). The server should have at least 8 vCPUs, 16GB of memory, and 100GB of storage. Additionally, the server must have a USB port for booting from an ISO.

> **IMPORTANT**  
> There is currently an [issue](https://issues.redhat.com/browse/MGMT-18693) with the USB partition table when created with the OpenShift Appliance ISOs (covered in Section 3 of this demo). This issue may prevent your system from booting directly from the USB. If you encounter this problem, consider using the RAW image (for both physical and virtual systems) or deploying the OpenShift Appliance in a VM (mounting with Virtual Media is not affected).

If you are using physical hardware for the edge device, the following equipment is recommended:

- One x86 server for the SNO device (8 CPU cores, 16GB RAM, 100GB+ disk, and one NIC). For Demo Section 2 (GitOps Provisioning with ACM), the server should have a Redfish BMC. If BMC is not available, consider using a VM with a virtual BMC for that section.
- Two USB keys, one with at least 64GB capacity.
- A USB keyboard (a USB RFID mini keyboard is suitable, but avoid Bluetooth-only models).
- A video cable and possibly an HDMI-DisplayPort adapter and an external monitor for boot console display. Alternatively, use a video capture card to view the physical device's video output on your laptop.
- A router capable of configuring PAT rules and/or a VPN.
- A network switch if your router/AP lacks sufficient free interfaces.
- At least three RJ45 cables.
- Depending on your laptop, additional adapters (e.g., RJ45 or HDMI) may be necessary. For example, some venues using HDMI over RJ45 may require specific adapters to ensure proper screen mirroring.

## 1. Base Environment Setup

Refer to the [base environment setup document](../../../bootstrap-environment/doc/bootstrap-environment-steps.md).

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

#### Network Connectivity between Edge and Central Site
Red Hat Advanced Cluster Management (ACM) requires access to the device's OpenShift API. You can achieve this by either configuring NAT port forwarding for TCP/6443 to the SNO server or by establishing a VPN between the local network and the environment where ACM is running (e.g., AWS).

If using a VPN and deploying ACM on AWS, the [`tools` section](../../../tools) includes an [Ansible Playbook](../../../tools/aws_vpn/README.md) to help create a VPN between AWS and your local Linux KVM server/laptop or OpenWRT router.

  > **Note**
  >
  > You can test the VPN by trying to SSH to one OpenShift Node's internal IP address from your Laptop/System.

### 2 - GitOps Provisioning with Advanced Cluster Management

#### Network Connectivity between Edge and Central Site
ACM needs access to both the OpenShift API and the Redfish BMC (default port TCP/8000). Port NAT can be configured for the API, and potentially for the BMC, but this section also requires direct connectivity. The device must download the "Discovery ISO" from one of the OpenShift Hub Cluster nodes' private IPs, which needs a VPN if the edge device is not on the same network as ACM. Remember that if ACM is in AWS, you can use the [provided playbooks to set up the VPN](../../../tools/aws_vpn/README.md).

#### Virtual BMC and OpenShift Single Node VM

If you don't have a physical device with BMC, you can deploy your Edge device (Single Node OpenShift) using a Virtual Machine and manage it with a Virtual BMC service.

In the [`tools` section](../../../tools), you can find several scripts that [enable a Virtual BMC in your KVM host](../../../tools/virtual-bmc/README.md) and others that help [create the SNO Virtual Machine](../../../tools/libvirt-sno/README.md) and the associated network and storage configuration in KVM.

### 3 - OpenShift Appliance

#### Base and Config Images Creation
To save time (around one hour), it's recommended to create the OpenShift Appliance Base and configuration Images beforehand. To make this process easier, you will find in the [`tools` section](../../../tools) some [Ansible Playbooks to create the OpenShift Appliance Assets](../../../tools/ocp-appliance/README.md). These playbooks not only help in creating the default images but also allow easy inclusion of custom manifests and container images into the images.

I also recommend creating the associated USB keys with those images if you plan to use physical hardware as a preparation step.

#### Single Node OpenShift Virtual Machine
You can also use the script for [creating the SNO Virtual Machine](../../../tools/libvirt-sno/README.md) and the associated resources in KVM if you need to deploy the OpenShift Appliance in a Virtual Machine.