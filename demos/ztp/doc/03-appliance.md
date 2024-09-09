# Section 3 - OpenShift Appliance

## Recording
TBD


## Environment review

For this section you don't need the Central Site to perform the OpenShift Zero-Touch Provisioning, since we will be generating the OpenShift Appliance Image using a single Linux system (ie. laptop).


## Preparation

Remeber to double-check that [all the pre-requirements are met](00-preparation.md) before jumping into the demo steps.

While preparing the OpenShift Appliance Images you will be able to setup static IPs (in `agent-config.yaml`) and also select the `capabilities` (in `install-config.yaml`) that you want to enable as part of the Cluster (ie. if you want to demonstrate how to save resources).


## Demo steps

### 1. Deploying the Base Image

> **NOTE**
>
> Remember that the Base and the Config image has been created during the preparation phase in order to save time. Check the [preparations doc](00-preparation.md) and the OpenShift [Appliance Ansible playbooks](../../../tools/ocp-appliance/README.md).












Si quieres puedes ver el log en `sudo podman logs -f 8fc71e1c987d` siendo el id del container, este es un ejemplo del log final de la generación del RAW image:
❯ sudo podman logs -f 8fc71e1c987d
WARNING OCP release version 4.16.4 is not supported. Latest supported version: 4.15. 
INFO Successfully downloaded appliance base disk image 
INFO Successfully extracted appliance base disk image 
INFO Successfully pulled container registry image 
INFO Successfully pulled OpenShift 4.16.4 release images required for bootstrap 
INFO Successfully pulled OpenShift 4.16.4 release images required for installation 
INFO Successfully generated data ISO              
INFO Successfully fetched openshift-install binary 
INFO Successfully downloaded CoreOS ISO           
INFO Successfully generated recovery CoreOS ISO   
INFO Successfully generated appliance disk image  
INFO Time elapsed: 33m13s                         
INFO                                              
INFO Appliance disk image was successfully created in assets directory: assets/appliance.raw 
INFO                                              
INFO Create configuration ISO using: openshift-install agent create config-image 
INFO Download openshift-install from: https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.16.4/openshift-install-linux.tar.gz 




demo start:
- deploy the image with the base usb
- deploy config
- check ip, check /etc/assistecd/ 
- when finish: check apps, check operators




-> se puede ver el progreso con `watch "oc --kubeconfig image-config/auth/kubeconfig get pod --all-namespaces"` y también en los containers de root (podman logs y también crictl logs)

also oc --kubeconfig output/image-config/auth/kubeconfig get clusterversion and also "get co"







base

reboot

Agent Install (config ISO)

reboot

ostree-0  (upgrade ?)

reboot 

recovery reinstall cluster  (it also appears ostree-1 and if you click it works)



