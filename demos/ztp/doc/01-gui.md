# Section 1 - Assisted Installer with Advanced Cluster Management

## Recording
TBD


## Environment review



## Demo steps

### 0. Configure DNS

### 1. Configure the inventory and OpenShift cluster in ACM.

### 2. Create and download the "Discovery ISO" from ACM.

### 3. Boot the device from the "Discovery ISO."

### 4. Approve the device in ACM.

### 5. Launch the OpenShift cluster deployment from ACM.





## Closing
































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

