# PART 1

In this part we just need to install a k3s worker and server, they can communicate between us in a private network

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

VM_CORE_SERVER=2
VM_MEMORY_SERVER=2048
# Network config
IP_NODE_S=192.168.56.110
IP_NODE_SW=192.168.56.111

# Token server
K3S_TOKEN=?
```