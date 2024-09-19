# Summary and demo step guide

This is the summary of the demo steps:

1. [Section 1 - Assisted Installer with Advanced Cluster Management](01-gui.md)
    1. Configure the Inventory and OpenShift Cluster in ACM (**Infrastructure > Host Inventory**)
        - Create Infrastructure environment
        - (optional) Create static network configuration ([sno-1-network.yaml](../demo-manifests/00-gui/sno-1-network.yaml))
        - Download Discovery ISO and boot device from it

    2. Launch the OpenShift Cluster Deployment from ACM (**Infrastructure > Clusters**)
        - Include information of the new Cluster
        - (optional) Include in YAML the OpenShift baseline capabilities ([annotation](../demo-manifests/00-gui/install-config-overrides.yaml))
        - Install Cluster and wait until it's with all the add-ons ready
        
    3. Check your OpenShift Deployment
        - New Cluster is Part of the ClusterSet
        - Cluster Policy Has Been Applied: `oc get subs --all-namespaces`
        - Test Application Was Deployed: `oc get route -n hello`

2. [Section 2 - GitOps Provisioning with Advanced Cluster Management](02-gitops.md)
    1. Create the [00-gitops-bmc-secret.yaml](../demo-manifests/01-gitops/00-gitops-bmc-secret.yaml) and next the Pull-Secret [01-gitops-pull-secret.yaml](../demo-manifests/01-gitops/01-gitops-pull-secret.yaml)
    2. Create the Bootstrap ArgoCD Application Object: [02-argocd-app.yaml](../demo-manifests/01-gitops/02-argocd-app.yaml)
    3. Wait Until the Device Is Onboarded (**Infrastructure > Clusters**)
    4. Check Your OpenShift Deployment
        - New Cluster Is Part of the ClusterSet
        - Cluster Policy Has Been Applied: `oc get subs --all-namespaces`
        - Test Application Was Deployed: `oc get route -n hello`
        
3. [Section 3 - OpenShift Appliance](03-appliance.md)
    1. Deploy the Base Image
    2. Mount the Config Image
    3. Test Your OpenShift Appliance
        - Check Base Image customization: `oc --kubeconfig output/image-config/auth/kubeconfig get subs --all-namespaces`
        - Check Config Image customization: `oc --kubeconfig output/image-config/auth/kubeconfig get pod -n hello-world`

