#!/bin/bash

apk update && apk add curl

TOKEN="$1"

# Install K3s in agent mode and join the server
curl -sfL https://get.k3s.io | \
    K3S_URL=https://192.168.56.110:6443 \
    K3S_TOKEN="$TOKEN" \
    sh -s - agent \
    --node-ip 192.168.56.111