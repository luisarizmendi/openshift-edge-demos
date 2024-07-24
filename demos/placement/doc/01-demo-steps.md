# Workload Placement - Demo Steps

## Getting Started


### TL/DR


point to the summary



### Overview

hablar de la parte de storage que no se toca en esta demo



valores por entorno, eso es bueno para diferentes images en edge de cloud



seimpre puedes crear una app objet per app and per cluster pero aqui vamos a simplificar



tres acercamientos, uno cambiando objecto en openshift, otro cambiando fichero en git y otro con config acm (y otras cosas automaticas)


say all tried to be gitops

two different application images to make it more realistic


decir que en sections tiene los ficheros




### Environment Walkthrough

After the environment and demo bootstrap you will have the Advanced Cluster Management and the Arco CD Controller ready in your OpenShift Hub Cluster. You can see how, for this demo, a couple of `ClusterSets` have been pre-defined in ACM, "cloud" and "edge", and that the Hub Cluster is already part of the "cloud" `ClusterSet`.

Also manifest for Placement API usage were generated, but those will be explained during the demo steps below.

You can check that you have two Argo CD applications already created. The `advanced-cluster-management` application deployed ACM in your Hub Cluster, and the `bootstrap-demo-placement` prepared the environment for the demo (ie. creating the already mentioned `ClusterSets`).

In addition, now you should have one or more additional OpenShift clusters ready to be used during the demo steps.


## Demo sections

### 0 - Importing additional OpenShift Clusters

During the demo we will be scheduling applications across multiple OpenShift clusters, so you will need to have more than a single OpenShift managed by ACM and Argo CD.

In this demo example we will be using one "Cloud" cluster (the "Hub") and one additional Edge cluster. The Hub cluster must be already imported in ACM (`local-cluster`) so we just need to add the additional Edge cluster.

There are three ways of importing a cluster:
* Run the import commands manually
* Enter Server URL and API token
* Using the `kubeconfig`

Personally I find the server URL and API token the most straighforward since you can obtain them easily:

1. Open the OpenShift cluster console in the cluster that you want to import
2. Click on the top right corner where you see your user (`kube:admin` if using "kubeadmin" user)
3. Click on "Copy login command" and then "Display token"
4. Copy the `token` and `server` parameters

With that info you can proceed to import the cluster. Be sure that you select the "edge" `ClusterSet` and **you name it as "edge-1"**, since the APP environment variables are prepared for that cluster name, otherwhise you will need to modify the Helm variables during the demo steps.

![](../doc/images/00-import-cluster.png)


### 1 - Placement with Argo CD ApplicationSet Generators

In this first section you will explore how to use `ApplicationSet` Generators to create the different `Application` objects for your APPs depending on which OpenShift cluster you want to deploy to.

Proceed with the [Placement with Argo CD ApplicationSet Generators demo steps](../doc/sections/01-generators.md).


### 2 - Placement with Helm and Argo CD Application manifests





### 3 - Placement with ACM and Placement API

explain placement api


create static workload


explain taint, tolerations preference, groups and more


deploy dynamic with preference





## Closing






## Going beyond


latency with custom priority











