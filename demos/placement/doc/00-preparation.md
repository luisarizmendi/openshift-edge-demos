# Workload Placement - Demo Preparation

## Environment & Hardware requirements 

* **OpenShift "Hub" Cluster**: Typically configured with 3 worker nodes, each possessing 8 cores and 16GB of memory.
* **OpenShift "Near-Edge" Clusters**: At least one additional OpenShift cluster (Minimum resources is ok). 

## Environment Setup

All demo deployments comprehends two main groups of steps:

1. **OpenShift "Hub" Cluster base configuration**: Typically two primary components:
   - Advanced Cluster Management (ACM)
   - OpenShift GitOps Operator

2. **Demo specific setup**

### Base configuration

You need to complete these steps before deploying your demo:

1. **Prepare your OpenShift Clusters**: Ensure you have freshly installed the required OpenShift clusters. The demo has been tested with OpenShift 4.16.

2. **Apply the Base Configuration in the Hub Cluster**:
   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [bootstrap-environment.yaml](../../bootstrap-environment/bootstrap-environment.yaml) file.

![](../../../doc/images/bootstrap-environment-deploy.gif)

  > **NOTE**
  >
  > It's possible that if you try to access ACM as soon as the web plugin update message appears, you will get another warning message that says "Red Hat Advanced MAangement for Kubernetes is not ready".Just wait a little bit more time so the ACM is completely up.

3. **Wait until you can open the Advanced Cluster Manager console**

![](../../../doc/images/bootstrap-environment-wait.gif)


### Demo specific configuration

Now you can deploy the components needed by your demo and apply the required configuration.

4. **Apply the demo specific setup**
   - Access your OpenShift console in the Hub cluster.
   - Click the `+` button to add resources.
   - Paste the content from the [bootstrap-demo.yaml](bootstrap-demo/bootstrap-demo.yaml) file.

![](images/bootstrap-demo-deploy.gif)

5. **Wait until you can see all applications in "Sync"status in the Argocd console** 

![](images/bootstrap-demo-wait.gif)


Once the setup is complete, you can proceed with the demo steps.
