
"Warning alert:Central Infrastructure Management is not running."

"Metal3 operator is not configured
The Metal3 operator is not configured correctly, which prevents it from finding bare metal hosts in this namespace. Refer to the documentation for the first time setup steps."






















DNS config

siteconfig/demo-gitops
    -> basename and hostName
    -> machineNetwork
    -> bmcAddress
    -> bootMACAddress


optional: installConfigOverrides, ignitionConfigOverride, nodeNetwork


VPN -> ping node


-------------


apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: demo-ztp-gitops-global
  namespace: openshift-gitops
  labels:
    app.kubernetes.io/managed-by: demo-ztp-gitops
spec:
  goTemplate: true
  goTemplateOptions: ["missingkey=error"]
  generators:
    - git:
        repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
        revision: main
        directories:
        - path: demos/ztp/demo-manifests/01-gitops/resources/argocd/
  template:
    metadata:
      name: "{{`{{.path.basename}}`}}-{{ .name }}"
      labels:
        app.kubernetes.io/managed-by: demo-placement-global
    spec:
      project: default
      source:
        repoURL: 'https://github.com/luisarizmendi/openshift-edge-demos.git'
        targetRevision: main
        path: "{{`{{.path.path}}`}}"
      destination:
        server: 'https://kubernetes.default.svc'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true







----
apiVersion: v1
kind: Secret
metadata:
  name: demo-ztp-gitops-bmc-secret-1
  namespace: sno-gitops
data:
  password: Ym9iCg==
  username: Ym9iCg==
type: Opaque






---
kind: Secret
apiVersion: v1
metadata:
  name: demo-ztp-gitops-pull-secret
  namespace: sno-gitops
data:
  '.dockerconfigjson': '<pull_secret in one line base64 > '
type: 'kubernetes.io/dockerconfigjson'



