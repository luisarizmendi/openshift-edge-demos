




recordar que tarda tiempo los demo-ztp-cluster y demo-ztp policies porque se está aplicando el path




crear namespace "demo-ztp" con los secrets

cat ~/pull-secret | base64 -w0




assisted can take time while populating





check that new argocd repo pod is generated and not in pedning because no resources








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