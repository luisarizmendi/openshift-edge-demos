# Placement with Helm and Argo CD Application Manifests

This approach leverages a "parent" `Application` object to generate `ApplicationSet` manifests (one per cluster) using Helm templates. Each generated `ApplicationSet` will, in turn, create corresponding `Application` manifest objects based on directories where the application resources are placed.


```
                                                                                  --> Child Application (dir 1)
                                                                                 /
                               --> Child ApplicationSet Cluster 1 ---(generator) ----> Child Application (dir 2)
                             /                                                   \
                             |                                                    --> Child Application (dir N)
                             | 
                             | 
                             |                                                    --> Child Application (dir 1)
                             |                                                   /                             
Parent Application ---(Helm) ----> Child ApplicationSet Cluster 2 ---(generator) ----> Child Application (dir 2)
                             |                                                   \
                             |                                                    --> Child Application (dir N)
                             | 
                             |                              
                             |                                                    --> Child Application (dir 1)
                             \                                                   /
                               --> Child ApplicationSet Cluster N ---(generator) ----> Child Application (dir 2)
                                                                                 \
                                                                                  --> Child Application (dir N)
```


This approach provides great flexibility by using Helm templating to create any Kubernetes manifest. You can modify the server URL along with other values such as paths, names, etc.

Refer to the Helm [values](../../sections/01-helm/resources/00-argocd-app/values.yaml) and the [template](../../sections/01-helm/resources/00-argocd-app/templates/application.yaml) used as the base for this demo.

At the beginning of the demo, only the Cloud (Hub) Cluster will be uncommented in the [values](../../sections/01-helm/resources/00-argocd-app/values.yaml) file. During the steps, you will modify these values in the Git repository and see how changes are reflected on the apps deployed using Argo CD.

## Deploy on Cloud

To deploy the child applications, create the parent application object targeting the location of the Helm Chart that creates the child application manifests:

1. Access your OpenShift console in the Hub cluster.
2. Click the `+` button to add resources.
3. Paste the following content, changing the `repoURL` to point to your own repo:

    ```yaml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: demo-placement-global
      namespace: openshift-gitops
      labels:
        app.kubernetes.io/managed-by: demo-placement-global
    spec:
      project: demo-placement

      source:
        repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
        targetRevision: main
        path: demos/placement/demo-manifest/02-helm/resources/00-argocd-app

      destination:
        server: 'https://kubernetes.default.svc'

      syncPolicy:
        automated:
          prune: true
          selfHeal: true
    ```

After a few seconds, you will find in the Argo CD Web UI that, along with the `demo-placement-global` you just created, there is the `hello-local-cluster` Child Application (indicating that the "hello" app is being deployed in the "local-cluster" OpenShift cluster).

> **NOTE**
> 
> Please note that the `ApplicationSet` objects are not shown in the Argo CD UI.

## Deploy on Edge

Next, modify the [values](../demo-manifest/02-helm/resources/00-argocd-app/values.yaml) to remove the "hello" app from the "Cloud" cluster and run it on "Edge" clusters.

> **NOTE**
> 
> In this demo we are using a single Git repo, but it's a good idea to place this value file in a different repo that can be edited by any person or system without affecting other aspects of the environment.


You can `pull` the repository locally onto your laptop, but for convenience, we will change the values directly in GitHub for this demo:

1. Edit the values file in your GitHub repository (`demos/placement/demo-manifest/02-helm/resources/00-argocd-app/values.yaml`).
2. Uncomment the examples of cluster descriptions, add your Edge clusters, and comment out the `local-cluster` entry. Commit the changes.
3. If you don't want to wait, open the Argo CD UI and click `REFRESH APPS`.

You will see how the "hello" app deployed in the `local-cluster` starts being deleted and, at the same time, is deployed in the specified clusters in the `values` file.

## Clean-Up

Once you have finished moving the app around your clusters, you can delete the `Application` and `ApplicationSet` objects:

1. Access your OpenShift console in the Hub cluster.
2. Click the `+` button to add resources.
3. Paste the following content:

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
      generateName: cleanup-demo-placement-global-
      namespace: openshift-gitops
    spec:
      template:
        spec:
          serviceAccountName: openshift-gitops-argocd-application-controller
          containers:
            - name: delete-apps
              image: openshift/origin-cli:latest
              command: ["oc"]
              args: ["delete", "applications", "-n", "openshift-gitops", "-l", "app.kubernetes.io/managed-by=demo-placement-global"]
            - name: delete-appsets
              image: openshift/origin-cli:latest
              command: ["oc"]
              args: ["delete", "applicationsets", "-n", "openshift-gitops", "-l", "app.kubernetes.io/managed-by=demo-placement-global"]
          restartPolicy: Never
    ```

## Going beyond

You can try to create groups of clusters, so instead of selecting in the Helm values file cluster by cluster you would point to a "group of clusters". You could do it by using the Helm templates to create the associated `ApplicationSets` that, using a similar approach to the previous section, will generate the `Application` objects per cluster and per APP.

## Next Section

 [3 - Placement with ACM and Placement API](03-placement.md)