# Placement with ACM and Placement API





## Deploy on Cloud



## Deploy on Edge



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


