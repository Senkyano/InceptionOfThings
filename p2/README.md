# PART 2

In this part2 we need to launch 3 web application with kubernetes and we can access to them with their own url or default

## Variable ENV

```bash
# PATH save vm
PATH_VM_LOAD=?

# ssh-key path
PATH_ID_RSA_PUB=?

# System config
VM_BOX=generic/alpine319
VM_VERSION_BOX=4.3.12
VM_MEMORY=1024
VM_CORE=1

VM_TAG=rihoySP2
VM_NAME=rihoySP2

VM_CORE_SERVER=2
VM_MEMORY_SERVER=2048
# Network config
IP_NODE_S=192.168.56.110

# Token server
K3S_TOKEN=?
```

````bash
# CLUSTER STATE
kubectk get pods
kubectl get nodes
kubectl get svc
kubectl get svc -n ingress-nginx

````
