# Workload Placement Across Multiple OpenShift Clusters

## Background

### The Challenge

Imagine you have an architecture consisting of one or more OpenShift clusters deployed on the public cloud or core data centers, along with a medium to high number of clusters in a small data center environment closer to where the data is generated and consumed (edge) or even a high number of clusters running very close to the end user and data sources (far-edge).

Now, you need to deploy an application. Where should you locate it? You might think that since this is an edge computing use case, the application should be as close as possible to the user and data source. While that's often true, there are times when it might be more convenient to deploy the application in the edge or even in the core data center, depending on the environmental conditions.

Far-edge devices typically have limited resources, so you need to be cautious about what you deploy on them. For instance, if you have two versions of your application—a standard and a "lite" version—you should ensure that the "lite" version is deployed on far-edge devices. It's also better to deploy only essential applications on these devices to conserve resources. If it doesn't significantly impact your use case or budget, utilizing resources from the edge or core data center might be preferable, thereby preserving far-edge resources for critical applications.

You would prefer to deploy your application at the far-edge only if it doesn't overly tax the device's resources. In more advanced setups, deployment decisions could also depend on network statistics. For instance, if low-latency response is crucial, network latency will be a key factor in determining whether to deploy at the far-edge (if latency is high) or save resources by deploying the "high-end" version at the edge or core (if latency is low). This complexity increases if these conditions change dynamically over time and you want to adjust your application location accordingly (e.g., edge locations could be mobile, such as on a train, ship, or vehicle).

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

## Architecture

![](doc/images/architecture.png)


## Preparation and Requirements

* [Preparation and requirements ](doc/00-preparation.md).

## Demo

**Time required for demo**: <30 minutes

### TL/DR

If you already know the demo details and just want a list of demo steps, you can jump into the [steps summary](doc/steps-summary.md).


### Demo Overview

In this demo, we will explore how to select the appropriate OpenShift cluster for deploying an application (APP) using Argo CD. Additionally, we will demonstrate how to modify the APP's configuration based on the target cluster. This capability is particularly valuable when deploying different environments, such as using a lightweight container image for Edge deployments and a more resource-intensive configuration for Cloud or Core Datacenters.

> **NOTE**
> 
> In this demonstration, we will illustrate this capability by changing the values of a ConfigMap displayed by a web server hosted by the APP.

While it is possible to manage cluster selection by creating individual Argo CD Application manifests, this approach can be complex and challenging to maintain at scale. Instead, we will showcase three different approaches that simplify the management of application placement, which is essential for edge computing scenarios.

> **NOTE**
> 
> It is important to note that this demo does not cover persistent storage considerations. We assume that the APPs being deployed do not require data persistence, such as those used for actuators, machine learning model inference, and similar use cases.


### Demo sections

 [1 - Placement with Argo CD ApplicationSet Generators](doc/01-generators.md)

 [2 - Placement with Helm and Argo CD Application manifests](doc/02-helm.md)

 [3 - Placement with ACM and Placement API](doc/03-placement.md)



## Closing

We have seen three different ways to manage the APP placement. The first one was using an implicit feature of the ApplicationSet objects, the generators, that permitted the creation of multiple Application objects based on the contents of subdirectories in a Git repository and a static list of OpenShift clusters used as targets.

This approach removed the need to manually create a single Application manifest for each APP and Cluster pair.

ApplicationSet generators offer a limited set of template/value options. To enhance flexibility, we introduced a more powerful templating tool, Helm. The second option we explored was creating the initial ApplicationSet using Helm, which provides many more options for customizing target cluster selection and APP value customization.

Additionally, with this approach, we demonstrated how to place the values file used by Helm in a Git repository, enabling us to manage APP placement following GitOps practices.

While Helm offers greater flexibility, it still lacks one "nice to have" feature: dynamic APP placement.

Advanced Cluster Management adds the Placement API into the picture, providing a way to filter the clusters used as targets for our APP deployment. It also allows configuring the number of replicas per group of clusters and setting preferences among the available clusters. This enables the configuration of advanced placement topologies that can adapt over time to the ever-changing environment, ensuring the best response to end-users.






XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX