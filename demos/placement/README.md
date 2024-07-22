# Workload Placement Across Multiple OpenShift Clusters

## Background

### The Challenge

Imagine you have an architecture consisting of one or more OpenShift clusters deployed on the public cloud or core data centers, along with a medium to high number of clusters in a small data center environment closer to where the data is generated and consumed (near-edge) or even a high number of clusters running very close to the end user and data sources (far-edge).

Now, you need to deploy an application. Where should you locate it? You might think that since this is an edge computing use case, the application should be as close as possible to the user and data source. While that's often true, there are times when it might be more convenient to deploy the application in the near-edge or even in the core data center, depending on the environmental conditions.

Far-edge devices typically have limited resources, so you need to be cautious about what you deploy on them. For instance, if you have two versions of your application—a standard and a "lite" version—you should ensure that the "lite" version is deployed on far-edge devices. It's also better to deploy only essential applications on these devices to conserve resources. If it doesn't significantly impact your use case or budget, utilizing resources from the near-edge or core data center might be preferable, thereby preserving far-edge resources for critical applications.

You would prefer to deploy your application at the far-edge only if it doesn't overly tax the device's resources. In more advanced setups, deployment decisions could also depend on network statistics. For instance, if low-latency response is crucial, network latency will be a key factor in determining whether to deploy at the far-edge (if latency is high) or save resources by deploying the "high-end" version at the near-edge or core (if latency is low). This complexity increases if these conditions change dynamically over time and you want to adjust your application location accordingly (e.g., edge locations could be mobile, such as on a train, ship, or vehicle).

### The Solution

Two components are essential to address this challenge: an easy way to deploy/undeploy applications and resources across multiple clusters, and smart scheduling.

The first component can be managed using [Argo CD](https://www.redhat.com/en/topics/devops/what-is-argocd). Argo CD provides declarative continuous delivery on Kubernetes, making it easy to deploy applications in any Kubernetes cluster. It also adapts to dynamic environments with features like "auto-sync."

For scheduling, while Kubernetes excels at scheduling containers across nodes within a cluster, you'll need a similar solution to decide which Kubernetes cluster to deploy applications to.

Argo CD offers ways to decide where to deploy applications, such as using Helm templating to create composable application manifests or using [ApplicationSet Generators](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators/). However, these methods lack some of the multi-cluster scheduling features found in Kubernetes, such as `Selectors`, `Taints/Tolerations`, etc.

This is where the [Open Cluster Management Placement API](https://open-cluster-management.io/concepts/placement/) comes in, offering features like `Selectors`, `Taints/Tolerations`, `Prioritizers`, and `Decision strategies`, which are similar to Kubernetes scheduling but at a multi-cluster level. The good news is that the Open Cluster Management Placement API is [already available in Advanced Cluster Management](https://www.redhat.com/en/blog/using-the-open-cluster-management-placement-for-multicluster-scheduling), providing a better way to dynamically control workload placement when using the GitOps (Argo CD) OpenShift Operator.

In this demo, you will explore the different methods for defining where your application should be deployed using Argo CD and Advanced Cluster Management. You'll see how their integration provides the capabilities needed to minimize the challenges described above.

## Concepts Reviewed During the Demo

* OpenShift GitOps
* Advanced Cluster Management Placement API

## Preparation and Requirements

You will find all the details in the [demo preparation and requirements doc](doc/00-preparation.md).

## Demo Steps

The demo will take less than 30 minutes. You will find all the details in the [demo steps doc](doc/01-demo-steps.md).
