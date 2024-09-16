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

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-ztp-gitops-global
  namespace: openshift-gitops
  labels:
    app.kubernetes.io/managed-by: demo-ztp-gitops
spec:
  project: default

  source:
    repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
    targetRevision: main
    path: demos/ztp/demo-manifests/01-gitops/resources/argocd/

  destination:
    server: 'https://kubernetes.default.svc'

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

After creating the object you can show:

* ArgoCD: Show how the applications go green while sync
* ACM: Infrstructure>Host Inventory
* Baremetal nodes: Home> API Explorer







show ....

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

As soon as you create the BMC password the baremetal inspection will start.




show ....




### 3. Wait until the device is onboarded







timeouts





si falla ver el url el en InfraEnv and connect to one of the nodes and try to run the sushy command to mount.
check that you can run VMs







remove applications







### 4. Check your OpenShift deployment



