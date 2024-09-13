# Section 2 - GitOps with ACM and BMC

## Recording
TBD


## Environment review

The environment has been prepared to perform Zero-Touch Provisioning with Assisted Installer using Redfish BMC. In contrast with the previous section, no further configuration was made in the cluster (ie. objects such as `Policies`, `ClusterSet`, `Placement`,...) since in this section everything will be created from a single ArgoCD Application object.


## Preparation

Remeber to double-check that [all the pre-requirements are met](00-preparation.md) before jumping into the demo steps.

It's important to remember that this section expect direct access from ACM into the device (ie. it downloads the ISO from one of the OpenShift node's private IP) so in case that you deployed ACM in an external network a VPN will need to be configured.

Alsom if you are using Virtual Machines instead of physical devices with real BMC, you need to be sure that the [virtual BMC](../../../tools/virtual-bmc/README.md) is up and running.

Also remember to check the DNS entries are working before moving into the demo steps.

---

## Demo steps

### 1. Create the bootstrap ArgoCD Application Object

ArgoCD will create all the required objets, you only need to create the ArgoCD Application following these steps:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [00-argocd-app.yaml](../demo-manifests/01-gitops/00-argocd-app.yaml) file:











show ....

















### 2. Create the pull-secret and BMC secrets

First create a secret containing your pull-secret token in the OpenShift cluster namespace:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [01-gitops-pull-secret.yaml](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml) file:

> **NOTE**
> Remember that you create the [01-gitops-pull-secret.yaml](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml) file during the demo preparation phase


Now create the BMC





















si falla ver el url el en InfraEnv and connect to one of the nodes and try to run the sushy command to mount.
check that you can run VMs










troubleshooting
-------------------------

remove applications

uefi???


timeouts