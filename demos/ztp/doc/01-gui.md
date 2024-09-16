# Section 1 - Assisted Installer with Advanced Cluster Management

## Recording
TBD


## Environment review

In order to simplify the demo, the environment has been prepared to minimize the steps that does not add anything relevant to what the demo tries to show (zero-touch provisioning), that's why these objects have been already created in the environment for you:

* ClusterSet and ClusterSetBinding: To host the cluster that you are going to create in a differenciated group
* Placement: To select the clusters where to deploy applications and ACM policies under the new ClusterSet
* Policy: That is used to deploy an example operator (`openshift-compliance` in this case)
* GitOpsServer and ApplicationSet: In order to automatically deploy the `hello-world` test application in the new cluster when it is imported in ACM.
* AgentServiceConfig: The Assisted Installer service has been enabled


## Preparation

Remeber to double-check that [all the pre-requirements are met](00-preparation.md) before jumping into the demo steps.

Remember to check the DNS entries before moving into the demo steps.

---

## Demo steps

### 1. Configure the inventory and OpenShift cluster in ACM.

Although the GUI can be used to create the cluster and the related host inventory at once, in order to make the parts more clear to the audience, we will be creating first the host inventory and the we will use that inventory to create a new OpenShift Cluster.

* In ACM (All Clusters tab) go to "Infrastructure > Host Inventory" and click "Create infrastructure environment"

* Provide a name (ie. `sno-gui`), a location name and your pull-secret. Optionally mark the "Static IP" Network type if you plan to setup static IPs and include your public SSH key to being able to access the OpenShift nodes using SSH. Click "Create"


* (optional) If you selected "Static IP" you will need to create the associated NMState object, you can click the `+` OpenShift button and add paste [sno-1-network.yaml](../demo-manifests/00-gui/sno-1-network.yaml) after addapting it to your values


* Click "Host" tab and then "Add host" on the top right corner, selecting "With Discovery ISO" and download the Discovery ISO.

* Boot your edge device using the Discovery ISO.

> **NOTE**
> If you are using physical Hardware you will need to create a bootable USB from that ISO image (using `dd` or any other Software).

* After some time you will see the device in the Hostname list. Click "Approve host". Optional you can also change the name from the MAC Address to `sno-1.sno-gui.<domain>`.



### 2. Launch the OpenShift cluster deployment from ACM.

Once you have your device in the Inventory List, you can use it to create the OpenShift cluster.

* Go to "Infrastructure > Clusters" in ACM and click "Create cluster"

* Select "Host inventory", "Standalone", "Use existing hosts"

* Add the cluster details, including the cluster name (ie. `sno-gui`), the Cluster set (`demo-ztp-gui`), basedomain, check "Install single node OpenShift" and include your Pull secret. 











* enable yaml view and para reducir el sno añadir:

kind: AgentClusterInstall
metadata:
  annotations:
    agent-install.openshift.io/install-config-overrides: |
      {"networking":{"networkType":"OVNKubernetes"},
        "capabilities": {
          "baselineCapabilitySet": "None",
          "additionalEnabledCapabilities": [
            "NodeTuning",
            "OperatorLifecycleManager",
            "marketplace",
            "Ingress"
          ]
        }
      }


cuando lo revisas no aparecen las annotations (la pagina con el fondo blanco) pero si están ahí






Then click "Next", "Next again" (no further automation needed) and lastly "Save".









2) create new cluster->host inventory->standalone > Use exsitiing host

* include: clsuter name, cluster set, base domain, "install sno", pull-secret


* Autoselect host or manually, next

* (optional add ssh key), next

* Click "Install cluster" and Wait







3) Check argocd, it should install the demo hello app













### 3. Check your OpenShift deployment






