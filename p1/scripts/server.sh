#!/bin/bash

apk update && apk add curl

TOKEN="$1"

# Install K3s in server mode
curl -sfL https://get.k3s.io | \
    K3S_TOKEN="$TOKEN" \
    sh -s - server \
    --write-kubeconfig-mode 644 \
    --node-ip 192.168.56.110 \
    --advertise-address 192.168.56.110

# Wait until the K3s server is ready
until k3s kubectl get nodes >/dev/null 2>&1; do
    echo "Waiting for K3s server..."
    sleep 2
done

# Configure kubectl for the vagrant user
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config