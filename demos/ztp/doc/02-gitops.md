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











































"Warning alert:Central Infrastructure Management is not running."

"Metal3 operator is not configured
The Metal3 operator is not configured correctly, which prevents it from finding bare metal hosts in this namespace. Refer to the documentation for the first time setup steps."









    Failed to create image due to an internal error
    The requested RHCOS version (4.16, arch
    x86_64) does not have a matching OpenShift release image

AgentServiceConfig







DNS config

siteconfig/demo-gitops
    -> basename and hostName
    -> machineNetwork
    -> bmcAddress
    -> bootMACAddress


optional: installConfigOverrides, ignitionConfigOverride, nodeNetwork


VPN -> ping node


-------------


apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: demo-ztp-gitops-global
  namespace: openshift-gitops
  labels:
    app.kubernetes.io/managed-by: demo-ztp-gitops
spec:
  goTemplate: true
  goTemplateOptions: ["missingkey=error"]
  generators:
    - git:
        repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
        revision: main
        directories:
        - path: demos/ztp/demo-manifests/01-gitops/resources/argocd/
  template:
    metadata:
      name: "{{`{{.path.basename}}`}}-{{ .name }}"
      labels:
        app.kubernetes.io/managed-by: demo-placement-global
    spec:
      project: default
      source:
        repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
        targetRevision: main
        path: "{{`{{.path.path}}`}}"
      destination:
        server: 'https://kubernetes.default.svc'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true







----
apiVersion: v1
kind: Secret
metadata:
  name: demo-ztp-gitops-bmc-secret-1
  namespace: sno-gitops
data:
  password: Ym9iCg==
  username: Ym9iCg==
type: Opaque






---
kind: Secret
apiVersion: v1
metadata:
  name: demo-ztp-gitops-pull-secret
  namespace: sno-gitops
data:
  '.dockerconfigjson': '<pull_secret in one line base64 > '
type: 'kubernetes.io/dockerconfigjson'






















si falla ver el url el en InfraEnv and connect to one of the nodes and try to run the sushy command to mount.
check that you can run VMs