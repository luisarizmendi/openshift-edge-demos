




recordar que tarda tiempo los demo-ztp-cluster y demo-ztp policies porque se está aplicando el path




crear namespace "demo-ztp" con los secrets

cat ~/pull-secret | base64 -w0





check that new argocd repo pod is generated and not in pedning because no resources



sobre las VMs:
libvirt con current and maximum memory para tener mas memoria en la VM




DNS config -> se puede hacer en AWS




GUI
---------------


si tiene 16GB de memoria justo, puede que exista un tiempo despues de incluir el server que ponga 15 con algo... hay que esperar


steps:

1) create dns records

2) create new cluster->host inventory->standalone->Add new hosts

3) include: clsuter name, base domain, "install sno", pull-secret

4) enable yaml view and para reducir el sno añadir:

kind: AgentClusterInstall
metadata:
  annotations:
    agent-install.openshift.io/install-config-overrides: |
      {"networking":{"networkType":"OVNKubernetes"},
        "capabilities": {
          "baselineCapabilitySet": "None",
          "additionalEnabledCapabilities": [
            "NodeTuning",
            "OperatorLifecycleManager",
            "Ingress"
          ]
        }
      }



cuando lo revisas no aparecen las annotations (la pagina con el fondo blanco) pero si están ahí







siteconfig
---------------

VPN





appliance
----------------
poner el vars_secret



necistas bastante espacio de disco (en mi prueba 170GB), también tener en cuenta que la iso es de 32 GB:
appliance_assets/build-image/output on  main [!] 
❯ ls -lh
total 61G
-rw-r--r--. 1 root root 32G Aug  5 09:57 appliance.iso
-rw-r--r--. 1 root root 29G Aug  5 09:47 appliance.raw

appliance_assets/build-image/output on  main [!] 
❯ ls -lh ../../build-
build-config-iso/ build-image/      

appliance_assets/build-image/output on  main [!] 
❯ ls -lh ../../build-config-iso/output/
total 56K
-rw-r--r--. 1 larizmen larizmen 56K Aug  5 09:57 agentconfig.noarch.iso
drwxr-x---. 1 larizmen larizmen  56 Aug  5 09:57 auth



estate seguro de que es la misma versión de openshift-install que la de la imagen





log into registry.redhat.io en usuario y root

pull secret cuidado con las comas simples, tiene que ser asi: pullSecret: '{"auths":{<redacted>}}'



install openshift-install  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/








BEYOND
static ip