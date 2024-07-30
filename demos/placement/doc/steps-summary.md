# Demo Summary

[1 - Placement with Argo CD ApplicationSet Generators](doc/01-generators.md)   
  - 1.1 Create the [ApplicationSet object](../demo-manifests/01-generators/00-argocd-appset.yaml) to deploy on Cloud
  - 1.2 Deploy on Edge by modifying the `ApplicationSet` in the Hub cluster to point to the "Edge" cluster
  - 1.3 [Clean up](../demo-manifests/01-generators/01-clean-up.yaml) the environment

[2 - Placement with Helm and Argo CD Application manifests](doc/02-helm.md)
  - 2.1 Create the [ApplicationSet object](../demo-manifests/02-helm/00-argocd-app.yaml) to deploy on Cloud
  - 2.2 To deploy in the Edge cluster clone the demo repo, change the [Helm values file](../demo-manifests/02-helm/resources/00-argocd-app/values.yaml) and push the changes
  - 2.3 [Clean up](../demo-manifests/02-helm/01-clean-up.yaml) the environment

[3 - Placement with ACM and Placement API](doc/03-placement.md)
  - 3.1 Create the [Placement](../demo-manifests/03-placement-api/00-placement.yaml) object
  - 3.2 Create the initial ClusterClaim objects for the [Cloud](../demo-manifests/03-placement-api/01-clusterclaim-cloud.yaml) and for the [Edge](../demo-manifests/03-placement-api/01-clusterclaim-edge.yaml)
  - 3.3 Deploy the APP in the Cloud cluster by creating the [ApplicationSet](../demo-manifests/03-placement-api/02-argocd-appset.yaml)
  - 3.4 Deploy in the Edge by modifying the ClusterClaim in the edge cluster from "bad" to "good" and, if the APP is not moved, in the Cloud cluster from "good" to "bad"
  - 3.5 [Clean up](../demo-manifests/03-placement-api/03-clean-up.yaml) the environment

