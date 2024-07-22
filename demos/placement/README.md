 
# Workload placement accross multiple OpenShift clusters

## Background

### The challenge

Let's imagine that you have an architecture that comprehends one or few OpenShift clusters deployed on the Public Cloud or Core Datan Centers and a medium to high number of clusters in an small Data Center environment closer to where the data is generated and consumed (near-edge) or even a high number of clusters running really close to the end user and data sources (far-edge). 

Now you might need to deploy an application, Where should you locate it? You can think, this is an Edge Computing use case, so as close as the user and data source, and you are right, but sometimes it could be more convinient to deploy the application in the near-edge... or even in the Core depending on the environment conditions. 

Most of the time, the kind of device that you have in the far-edge does not have a great amount of resources, which means that you need to be cautious of what you deploy on them. For example, if you have two "versions" of your application, one standard and another one "little", you better be sure that you deploy the "little" version on the far-edge device. Also it's better that you only deploy on those devices the applications that are really needed, so if it does not highly affects your use case (and your pocket), it is better to use resources from your near-edge, or even the Core if it's possible, what will make more resources available in the far-edge for the applications that you really need to locate there.













dinamico



near-edge y movimiento




In any edge computing architecture you will have a high number of devices involved, so when you need to deploy an application you will need to decide where to deploy it.Managing the scale of number of devices of any edge computing use case could be challenging, but it is more when you need to decide where is the best place to locate your applications.


### The solution





Now think about the statement "if it does not highly affets your use case". This could mean that, for example, if your use case needs to have a low latency reponse, you will have in the network latency a key determing factor to know if you can deploy 




## Concepts reviewed during the demo

* OpenShift GitOps
* Advanced Cluster Management Placement API


## Preparation and requirements

You will find all the details in the [demo preparation and requirements doc](doc/00-preparation.md).

## Demo Steps

The demo will take less than 30 minutes. You will find all the details in the [demo steps doc](doc/01-demo-steps.md).
