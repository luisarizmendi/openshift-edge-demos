




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
    Success alert:1 host selected out of 1 identified.
    Total compute: 12 CPUs | 15.46 GiB Memory





steps:

1) create dns records

2) Add hosts to inventory > Create infrastructure environment

* Add env. name, localtion, pull secret

* (optional set static IP)

* Click Create


(NOTE: puedes encontrar un error trtansitorio en la web de que ciertos componentes no existen o no están corriendo correctamente. espera un minuto a ver si se van) algo como esto:

Danger alert:Failing infrastructure environment

    Failed to create image due to an internal error
    failed to find secret pullsecret-demo-sno-gui
    failed to get secret demo-sno-gui/pullsecret-demo-sno-gui from API
    secrets "pullsecret-demo-sno-gui" not found




* Create nmstate yaml with +

apiVersion: agent-install.openshift.io/v1beta1
kind: NMStateConfig
metadata:
  name: <node name>
  namespace: <environment name>
  labels:
    infraenvs.agent-install.openshift.io: <environment name>
spec:
  config:
    interfaces:
      - name: eth0
        type: ethernet
        state: up
        mac-address: <device mac>
        ipv4:
          enabled: true
          address:
            - ip: <ip address>
              prefix-length: <net mask>
          dhcp: false
    dns-resolver:
      config:
        server:
          - <dns server>
    routes:
      config:
        - destination: 0.0.0.0/0
          next-hop-address: <gateway ip>
          next-hop-interface: eth0
          table-id: 254
  interfaces:
    - name: "eth0"
      macAddress: "<device mac>"


example:

apiVersion: agent-install.openshift.io/v1beta1
kind: NMStateConfig
metadata:
  name: sno-gui
  namespace: demo-gui
  labels:
    infraenvs.agent-install.openshift.io: demo-gui
spec:
  config:
    interfaces:
      - name: eth0
        type: ethernet
        state: up
        mac-address: 84:8b:cd:4d:15:37
        ipv4:
          enabled: true
          address:
            - ip: 192.168.140.3
              prefix-length: 24
          dhcp: false
    dns-resolver:
      config:
        server:
          - 8.8.8.8
    routes:
      config:
        - destination: 0.0.0.0/0
          next-hop-address: 192.168.140.1
          next-hop-interface: eth0
          table-id: 254
  interfaces:
    - name: "eth0"
      macAddress: "84:8b:cd:4d:15:37"





* Download ISO


* Start device with ISO, wait and approve host



2) create new cluster->host inventory->standalone > Use exsitiing host

* include: clsuter name, cluster set, base domain, "install sno", pull-secret

* enable yaml view and para reducir el sno añadir:

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
            "marketplace",
            "Ingress"
          ]
        }
      }


cuando lo revisas no aparecen las annotations (la pagina con el fondo blanco) pero si están ahí

* Autoselect host or manually, next

* (optional add ssh key), next

* Click "Install cluster" and Wait







3) Check argocd, it should install the demo hello app



siteconfig
---------------

VPN





appliance
----------------


Configura DNS api.<name> and *.apps.<name>




poner el vars_secret. pull secret cuidado con las comas simples, tiene que ser asi: pullSecret: '{"auths":{<redacted>}}'

revisar vars.yaml (ip, dns name...).



log into registry.redhat.io en usuario y root




necistas bastante espacio de disco (en mi prueba 170GB), también tener en cuenta que la iso es de 32 GB:
appliance_assets/build-image/output on  main [!] 
❯ ls -lh
total 61G
-rw-r--r--. 1 root root 32G Aug  5 09:57 appliance.iso
-rw-r--r--. 1 root root 29G Aug  5 09:47 appliance.raw




install openshift-install desde  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/ pero estate seguro de que es la misma versión de openshift-install que la de la imagen (ocp_release_version)




OPTIONAL IP STATIC (in appliance_assets/build-config-iso/config/agent-config-template.yaml)
//
hosts:
  - hostname: sno-appliance
    interfaces:
      - name: eth0
        macAddress: 84:8b:cd:4d:15:37
    networkConfig:
      interfaces:
        - name: eth0
          type: ethernet
          state: up
          mac-address: 84:8b:cd:4d:15:37
          ipv4:
            enabled: true
            address:
              - ip: 192.168.140.3
                prefix-length: 24
            dhcp: false
      dns-resolver:
        config:
          server:
            - 8.8.8.8
      routes:
        config:
          - destination: 0.0.0.0/0
            next-hop-address: 192.168.140.1
            next-hop-interface: eth0
            table-id: 254

//


*** NOTE IF YOU CONFIGURE STATIC IP YOU NEED TO HAVE nmstatectl INSTALLED IN YOUR LAPTOP to check the config while creating the image-config iso. If you use Fedora do it by installing sudo nmstate package





OPTIONAL COMPOSABLE (in appliance_assets/build-config-iso/config/install-config-template.yaml)
//
capabilities:
  baselineCapabilitySet: None
  additionalEnabledCapabilities:
  - NodeTuning
  - OperatorLifecycleManager
  - marketplace
  - Ingress

//



crea la imagen e iso antes de comenzar la demo con el script 00-build-appliance.sh

NOTE: Takes time and needs reliable network (descarga 30GB en imagenes), 

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
- check that you can ssh, check ip, check container images
- deploy config
- check ip, check apps, check operators