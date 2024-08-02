




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

log into registry.redhat.io en usuario y root

pull secret cuidado con las comas simples, tiene que ser asi: pullSecret: '{"auths":{<redacted>}}'



install openshift-install  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/