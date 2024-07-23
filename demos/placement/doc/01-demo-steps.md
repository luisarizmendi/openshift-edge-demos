# Workload Placement - Demo Steps

## Getting Started

### Overview

say all tried to be gitops

two different application images to make it more realistic


decir que en sections tiene los ficheros




### Environment Walkthrough

After the environment and demo bootstrap you will have the Advanced Cluster Management and the Arco CD Controller ready in your OpenShift Hub Cluster. You can see how, for this demo, a couple of `ClusterSets` have been pre-defined in ACM:


<image>


Also manifest for Placement API usage were generated, but those will be explained during the demo steps below.

You can check that you have two Argo CD applications already created. The `advanced-cluster-management` application deployed ACM in your Hub Cluster, and the `bootstrap-demo-placement` prepared the environment for the demo (ie. creating the already mentioned `ClusterSets`)

<image>


In addition, now you should have one or more additional OpenShift clusters ready to be used during the demo steps.


## Demo sections

### 0 - Importing additional OpenShift Clusters

During the demo we will be scheduling applications across multiple OpenShift clusters, so you will need to have more than a single OpenShift managed by ACM and Argo CD.



en este ejemplo 1 cloud y dos edge



### 1 - Placement with Argo CD ApplicationSet Generators



explain generators


deploy in hub



change and deploy in edge



clear




### 2 - Placement with Helm and Argo CD Application manifests





### 3 - Placement with ACM and Placement API

explain placement api


create static workload


explain taint, tolerations preference, groups and more


deploy dynamic with preference





## Closing






## Going beyond


latency with custom priority











