# Create OpenShift Appliance Image and Configuration ISO

Creating an OpenShift Appliance image involves several steps (as detailed in [this article](https://access.redhat.com/articles/7065136)), but these Ansible Playbooks simplify the process.

There are two primary playbooks: one for creating the Base image (RAW and ISO formats) and another for generating specific per-cluster Configuration ISOs. Additionally, a shell script is provided to execute both playbooks simultaneously, which is useful for demos involving a single cluster.

## Prerequisites

- **Red Hat OpenShift Pull Secret:** Ensure you have your pull secret.
- **Openshift-install Binary:** The `openshift-install` binary must be installed on your system. Make sure to use the [same version](https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/) as the appliance, which is determined by setting the `ocp_release_version` variable in the `ansible/vars.yaml` file.
- **Disk Space:** Ensure sufficient disk space for the generated images. Approximately 170GB is needed during the appliance creation process (including container image downloads, with each appliance image consuming around 30GB). More space may be required depending on the operators and embedded images you include in the appliance.
- **USB Drives:** If installing on physical devices, you'll need two USB drives to store the Base and Configuration images. Note that the Base image could exceed 32GB.
- If you use static IPs, you will need to have `nmstate` package in your system


## Creating the Base and Configuration Images

### 1. Prepare Your Customizations

The OpenShift Appliance creation involves two steps: creating the "Base Image" and then generating a "Configuration ISO" for each specific cluster to customize that Base image.

Customizations can be introduced during each phase by adding files to directories dedicated to these phases.

In the `example-customizations` directory, you'll find two subdirectories:
- **`image-base`:** Contains customizations for the Base Image creation phase.
- **`image-config`:** Contains customizations for the Config ISO creation phase.

#### Base Image Customizations
- **`appliance-config-template.yaml`:** This is the base configuration file for the OpenShift appliance. It serves as a template, with additional sections (e.g., `additionalImages` and `operators`) added based on other configurations to create the `appliance-config.yaml` file used during appliance creation. The final `appliance-config.yaml` can be found in the `tmp-files` directory after running the script.
- **`custom-images.yaml`:** Specifies the images to embed into the appliance.
- **`custom-operators.yaml`:** Lists the Operators to embed into the appliance.
- **`iso-post-deployment.sh`:** Script for any post-creation steps to execute immediately after installing the Base image.
- **`custom-manifests` directory:** Contains manifests to be deployed in the Base image. These manifests will be available in all clusters deployed using this Base image. Only `.yaml` and `.yml` files are processed, and sub-directory structures are ignored.

#### Configuration ISO Customizations
You'll find one example directory for Config ISO customizations, but you will need a separate directory for each OpenShift cluster.
- **`agent-config-template.yaml`:** Template for the `agent-config.yaml` file, useful for network customizations (e.g., static IP).
- **`install-config-template.yaml`:** Template for the `install-config.yaml` file, allowing modifications such as adjusting baseline capabilities (to reduce the required Hardware footprint).
- **`manifests` directory:** Contains manifests to embed in a specific cluster.

> **NOTE:**
> At this moment `Route` objects cannot be part of the customization. This is going to be solved sortly.

### 2. Run the Script to Create the Images

Before running the script, ensure the values in `ansible/vars.yaml` are correct for your environment.

- **Key Variables:**
  - `appliance_assets_image` and `appliance_assets_config_iso`: Directories for OpenShift appliance customizations.
  - `ocp_release_version`: OpenShift release version (tested with 4.16.9).
  - `core_user_password`: Password for the Core user.

Also, check the customization variables for the Configuration ISO, such as the appliance device, system IP (Rendezvous IP in SNO), DNS base domain, and cluster name.

You will need to create a `ansible/vars_secret.yaml` file to include the `pullSecret` variable. It’s recommended to encrypt this file using Vault or similar tools. The expected format is:

```yaml
pullSecret: '{"auths":{<redacted>}}'
```

Ensure both your CLI user and the root user are logged into the `registry.redhat.io` container registry:

```shell
podman login -u <your user> registry.redhat.io

sudo podman login -u <your user> registry.redhat.io
```

Now, run the script:

```bash
./build-appliance.sh
```

> **Note**  
> The image creation process duration depends on your internet connection speed but for the provided example expect around a **60 minutes** wait, as it involves downloading over 30GB of container images. The Configuration ISO generation is significantly faster than the Base Image creation.

The script generates the Base image (RAW and ISO) and the Configuration ISO, all of which can be found in the `output` directory.

If you want to check the detailed logs while the image is being generated, you have to check the containers running in your system (root). You will see that there are multiple containers used to create the OpenShift Appliance, get the ID of the one that you want to review and then check its output (ie. `sudo podman logs -f 8fc71e1c987d`).

The process generates content inside the `output` directory, including the base image (ISO and RAW) under the `output/image-base` directory, and the `agentconfig.noarch.iso` configuration image and authentication files under `output/image-config`:

```bash
❯ tree output/
output/
├── image-base
│   ├── appliance.iso
│   └── appliance.raw
└── image-config
    ├── agentconfig.noarch.iso
    ├── agent-config.yaml
    ├── auth
    │   ├── kubeadmin-password
    │   └── kubeconfig
    └── install-config.yaml

```


### 3. If you need to deploy more than just one cluster...

You can create separate customization directories for each OpenShift cluster. Adjust the `ansible/var.yaml` variables accordingly for each run:

```shell
ansible-playbook -e  -vv ansible/build-image-config.yaml

```


## Using the generated images

You will have a Base image in both RAW and ISO formats, and as many Configuration ISOs as there are OpenShift clusters to deploy. The deployment workflow is as follows:

1. Use the RAW image to copy it to a disk (physical or virtual) or create a USB stick with the Base image ISO.

> **Note**  
> If using the RAW image, you may need to resize your partition to utilize the full disk space after copying the image.

2. Power on the device (booting from either the disk if using RAW or the USB/Virtual Drive if using ISO) and wait for the zero-touch provisioning to complete.

> **IMPORTANT**  
> There is currently an [issue](https://issues.redhat.com/browse/MGMT-18693) with the USB partition table when created with the OpenShift Appliance ISOs. This issue may prevent your system from booting directly from it. If you encounter this problem, consider using the RAW image (for both physical and virtual systems) or deploying the OpenShift Appliance in a VM (mounting with Virtual Media is not affected).

3. Create a USB with the Configuration ISO (or use the ISO in your device VM) and plug it into the system.

4. Wait until the OpenShift Cluster deployment is completed

