# OpenShift Zero-Touch Provisioning

## Overview

### The Challenge

Edge computing use cases often involve a large number of devices and locations, combined with a lack of on-site specialized personnel. This makes it impractical to use the same deployment approaches that are common in data centers or cloud environments. At the edge, we cannot rely on individuals to follow complex installation procedures, nor is it cost-effective or timely to send experts to each location.

### The Solution

To address these challenges, we can prepare all deployment assets in advance to automate the process as much as possible, enabling a "zero-touch provisioning" experience. While specialized personnel are still required, they can remain at a central location. The actual deployment at the edge can be carried out by anyone capable of booting a device from an ISO, eliminating the need for technical expertise on-site.

## Key Concepts Covered in the Demo

* Advanced Cluster Management (ACM)
* OpenShift GitOps
* OpenShift Appliance
* OpenShift Assisted Installer

## Architecture

The architecture for this demo comprises a central site, where Advanced Cluster Management (ACM) and OpenShift GitOps (ArgoCD) are deployed on top of Red Hat OpenShift, and the Edge locations (one is sufficient for this demo) where the devices will be installed with Single Node OpenShift (SNO). Additionally, a GitHub or any other Git repository will be used to host the GitOps manifests.

![Architecture Diagram](doc/images/architecture.png)

This Zero-Touch Provisioning demo highlights the power of Red Hat OpenShift in edge computing scenarios. If you're interested in exploring what's possible with Red Hat Device Edge and Ansible Automation Platform, be sure to check out the [Red Hat Device Edge and Ansible Automation Platform demos](https://github.com/luisarizmendi/rhde-aap-gitops-demo).


### Recommended Hardware

For the central site, deploying the OpenShift Hub cluster on AWS is recommended due to its ease of setup and scalability. However, OpenShift can also be deployed on other supported environments, including bare-metal servers—though this is not recommended for a demo due to the significant CPU and memory requirements.

For the edge site, the demo can be run on VMs or any `x86_64` server capable of running RHEL (this demo has not been tested with `aarch64`). The server should have at least 8 vCPUs, 16GB of memory, and 100GB of storage. Additionally, the server must have a USB port for booting from an ISO.

> **IMPORTANT**  
> There is currently an [issue](https://issues.redhat.com/browse/MGMT-18693) with the USB partition table when created with the OpenShift Appliance ISOs (covered in Section 3 of this demo). This issue may prevent your system from booting directly from the USB. If you encounter this problem, consider using the RAW image (for both physical and virtual systems) or deploying the OpenShift Appliance in a VM (mounting with Virtual Media is not affected).

If you are using physical hardware, the following equipment is recommended:

- One x86 server for the SNO device (8 CPU cores, 16GB RAM, 100GB+ disk, and one NIC). For Demo Section 2 (GitOps Provisioning with ACM), the server should have a Redfish BMC. If BMC is not available, consider using a VM with a virtual BMC for that section.
- Two USB keys, one with at least 64GB capacity.
- A USB keyboard (a USB RFID mini keyboard is suitable, but avoid Bluetooth-only models).
- A video cable and possibly an HDMI-DisplayPort adapter and an external monitor for boot console display. Alternatively, use a video capture card to view the physical device's video output on your laptop.
- A router capable of configuring PAT rules and/or a VPN.
- A network switch if your router/AP lacks sufficient free interfaces.
- At least three RJ45 cables.
- Depending on your laptop, additional adapters (e.g., RJ45 or HDMI) may be necessary. For example, some venues using HDMI over RJ45 may require specific adapters to ensure proper screen mirroring.

### Required Connectivity

Since OpenShift is being installed, you will need to configure the necessary DNS entries, including a wildcard, on a DNS server.

The level of network connectivity required between the central site and the edge location varies depending on the demo section:

#### Section 1 - Assisted Installer with Advanced Cluster Management

Red Hat Advanced Cluster Management (ACM) requires access to the device's OpenShift API. You can achieve this by either configuring NAT port forwarding for TCP/6443 to the SNO server or by establishing a VPN between the local network and the environment where ACM is running (e.g., AWS).

If using a VPN and deploying ACM on AWS, the [`tools` section](../../tools/) includes an [Ansible Playbook](../../tools/aws_vpn/README.md) to help create a VPN between AWS and your local Linux KVM server/laptop or OpenWRT router.

#### Section 2 - GitOps Provisioning with Advanced Cluster Management

ACM needs access to both the OpenShift API and the Redfish BMC (default port TCP/8000). Port NAT can be configured for the API, and potentially for the BMC, but this section also requires direct connectivity. The device must download the "Discovery ISO" from one of the OpenShift Hub Cluster nodes' private IPs, which necessitates a VPN if the edge device is not on the same network as ACM.

#### Section 3 - OpenShift Appliance

This section does not require a central site; in fact, the edge location can be entirely disconnected, provided the correct DNS entries are configured locally. You only need an Internet connection on the laptop or system where you create the OpenShift Appliance images.

## Preparation and Requirements

Refer to the [Preparation and Requirements Guide](doc/00-preparation.md) for detailed setup instructions.

## Demo Overview

**Time required for preparing the demo:** Less than 120 minutes

**Time required for delivering the demo:** Less than 90 minutes

### TL;DR

If you're already familiar with the demo details and just need a list of steps, you can skip to the [steps summary](doc/steps-summary.md).

### Demo Sections

This demo explores three different methods to deploy an OpenShift cluster (specifically, a Single Node OpenShift) using a zero-touch provisioning approach.

### [1 - Assisted Installer with Advanced Cluster Management](doc/01-gui.md)

In this section, we pre-configure the cluster in Red Hat Advanced Cluster Management (ACM) and create a Discovery ISO, which is used at the edge location to boot and auto-configure the device. These steps can be performed centrally by a specialized person, while the actual deployment can be done by anyone who knows how to boot the device from an ISO (e.g., via USB).

**Deployment Workflow:**

1. Configure the inventory and OpenShift cluster in ACM.
2. Create and download the "Discovery ISO" from ACM.
3. Boot the device from the "Discovery ISO."
4. Approve the device in ACM.
5. Launch the OpenShift cluster deployment from ACM.

Once OpenShift is installed, application delivery and cluster policy enforcement are automatically handled.

For multiple OpenShift clusters, repeat the above steps for each cluster.

**Detailed Workflow Diagram:**

![Assisted Installer Workflow](doc/images/acm-gui.png)

### [2 - GitOps Provisioning with Advanced Cluster Management](doc/02-gitops.md)

The previous workflow offers a zero-touch provisioning experience, but it can be further automated using a GitOps approach. Instead of performing steps in the ACM GUI, we'll create the necessary objects for cluster deployment and store them in a Git repository. 

Additionally, we can eliminate the need for on-site personnel to boot the device from the "Discovery ISO" by utilizing a [Baseboard Management Controller (BMC)](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface#Baseboard_management_controller) from the central site. This approach saves time and simplifies the process for edge personnel, although it requires appropriate connectivity and may increase device costs.

**High-Level Workflow:**

1. Configure ACM and create the OpenShift deployment objects.
2. Store these objects in a Git repository.
3. ACM powers on the device using the BMC.
4. The device downloads the discovery ISO directly from ACM.
5. The OpenShift cluster is auto-provisioned.

For multiple OpenShift clusters, create separate manifests for each cluster and push them to the Git repository.

**Detailed Workflow Diagram:**

![GitOps Workflow](doc/images/acm-gitops.png)

### [3 - OpenShift Appliance](doc/03-appliance.md)

The previous approach offers the most automation but requires a device with BMC and the associated connectivity. If such connectivity cannot be provided, or if it is slow or unstable, a different zero-touch provisioning method is required, in this case you can use the "OpenShift Appliance".

With the OpenShift Appliance approach, you create a device with all necessary manifests and images embedded, allowing for self-provisioning on first boot and automatic configuration when a USB with the required OpenShift customizations is inserted.

This method involves two key assets:

1. **Base Image:** This image contains all the container images and manifests common to all OpenShift clusters you plan to deploy. It can be either a RAW image that you burn directly onto the device or an ISO for first-time deployment.
2. **Configuration ISO:** This is unique to each cluster, containing specific cluster details (e.g., cluster name, base domain) and manifests.

**Simplified Workflow:**

1. Create the Base Image (can be done on your laptop; ACM is not required).
2. Create the Configuration ISO.
3. Burn the Base RAW Image onto the device or boot from the Base Image ISO.
4. Connect the Configuration ISO (this triggers automatic customization).

For multiple OpenShift clusters, create a different Configuration ISO for each one.

**RAW Image Workflow Diagram:**

![Appliance RAW Workflow](doc/images/appliance-raw.png)

**ISO Workflow Diagram:**

![Appliance ISO Workflow](doc/images/appliance-iso.png)

### Demo Recording

(TBD).

## Conclusion

In this demo, we've explored how to deploy OpenShift in edge computing scenarios where on-site specialized personnel are not available. OpenShift's flexibility shines in these challenging environments, offering multiple zero-touch provisioning methods tailored to various needs:

1. **Assisted Installer with ACM:** This method allows for the easy pre-configuration of clusters, enabling non-technical personnel at edge locations to deploy OpenShift simply by booting from an ISO. This approach minimizes human error and accelerates deployment timelines.

2. **GitOps with ACM and BMC:** By automating the deployment process further with GitOps and leveraging BMC for remote device management, you can reduce on-site interaction to nearly zero. This not only streamlines operations but also ensures consistency and scalability across numerous edge locations.

3. **OpenShift Appliance:** For disconnected or semi-disconnected environments, the OpenShift Appliance method provides a robust solution. It embeds all necessary components directly into the device, making deployment as easy as plugging in a USB stick. This approach is ideal for remote locations with limited connectivity, ensuring that OpenShift can be deployed anywhere, regardless of network conditions.

The benefits of using OpenShift for edge use cases are clear. It simplifies the complexities of deploying and managing Kubernetes clusters across dispersed and challenging environments, reduces the need for on-site technical expertise, and accelerates time-to-value. OpenShift’s robust and versatile tools make it an exceptional choice for organizations looking to extend their cloud-native capabilities to the edge, ensuring reliable, scalable, and secure operations no matter where your infrastructure resides.

