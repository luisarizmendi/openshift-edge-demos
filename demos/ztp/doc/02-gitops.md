# Section 2 - GitOps with ACM and BMC

## Recording
TBD

---

## Time required

TBD


---
## Environment review

The environment has been prepared to perform Zero-Touch Provisioning with Assisted Installer using Redfish BMC. In contrast with the previous section, no further configuration was made in the cluster (ie. objects such as `Policies`, `ClusterSet`, `Placement`,...) since in this section everything will be created from a single ArgoCD Application object.


---
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
   - Paste the content from the [00-argocd-app.yaml](../demo-manifests/01-gitops/00-argocd-app.yaml) file

After creating the object you can show:

* ArgoCD: Show how the applications go green while sync

  You can check in the ArgoCD portal three new Applications created. The "Global" Application is the one that triggers the deployment of the other two, the "Cluster" Application will create the objects to create the OpenShift clusters, while the "Policy" Application will create the related Policies and Placement onjects in ACM that will be applied to the new cluster.


* ACM: Infrastructure>Host Inventory

  You will see that a new Host inventory `sno-gitops` has been created. If you open it you also will see that there are still an object that is not yet created: The `pull-secret`, and if you check  the status of the Baremetal node, you will see a Registering error: `BMC CredentialsName secret doesn't exist`. You need to create both the `pull-secret` and the BMC user/password objects in order to start the cluster deployment.

> **NOTE**
> You might find a `Metal3 operator is not configured` warning message in the Host Inventory. Wait one minute to be sure that you gave enough time for the auto-configuration, if the message is still there you can try to remove the `provisioning-configuration` `Provisioning` object (it will be recreated by ArgoCD)

### 2. Create the pull-secret and BMC secrets

First create a secret containing your pull-secret token in the OpenShift cluster namespace:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [01-gitops-pull-secret.yaml](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml) 

> **NOTE**
> Remember that you create the [01-gitops-pull-secret.yaml](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml) file during the demo preparation phase

Now create the BMC:

   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [02-gitops-bmc-secret.yaml](../demo-manifests/01-gitops/02-gitops-bmc-secret.yaml) 

As soon as you create the BMC password the baremetal you will see in ACM "Infrastructure > Host Inventory" how the Inspection will start.


### 3. Wait until the device is onboarded

You will see in "Infrastructure > Host Inventory" that the baremetal host of the `sno-gitops` environment will progress accross different states: Registering -> Inspecting -> Provisioning.

> **NOTE**
> If this process fails you can check if the OpenShift Hub nodes can connect to the edge device BMC, also if you find issues and you want to start over, remove the ArgoCD Applications, be sure that the Baremetal, Secret and InfraEnv Objects are deleted, and create again the `00-argocd-app.yaml` (probably you will need to create the BMC secret again).

After the node is ready, the OpenShift Cluster installation will take place. You can monitor it in "Infrastructure > Clusters" selecting the `sno-gitops` cluster.

Once the cluster is installed and shows a **"Ready"** status under **Infrastructure > Clusters** it will start to "Import" the cluster, when that's done you just need to wait until all **Add-ons** are marked green, then you can continue to the next step.

### 4. Check your OpenShift deployment





>>>>>>>>>>>>>>>>>>>><


>


## Review

In this section we demonstrated how you can even remove the need of attaching the Discovery ISO and configuring the edge device to boot from USB, by using a device with BMC and the automations provided by ACM.

In this case we configured everything as objects in a Git source code repository, following the GitOps approach. We also have seen how, in order to describe our infrastructure and cluster, instead of creating the multiple objects that we generated using the GUI (`InfraEnv`, `AgentClusterInstall`, `NMStateConfig`, etc), we used a different approach by defining everything in a single `SiteConfig` file, that will be used to obtain the mentioned objects that are needed to install the OpenShift Cluster.


policy generator





