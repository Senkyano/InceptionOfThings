#!/bin/bash

echo "=== Install dependecies server K3s ==="

# Update
apk update && apk upgrade
apk add --no-cache curl

TOKEN=$1
SERVER_IP=$2
# apk add --no-cache virtualbox-guest-additions virtualbox-guest-modules-virt

# modprobe -v vboxsf

# mount -t vboxsf -o uid=$(id -u vagrant),gid=$(id -g vagrant) vagrant /vagrant

# Install K3s
echo "=== Installation K3s on mode Server ==="
curl -sfL https://get.k3s.io | sh -s - server \
	--token=$TOKEN \
	--disable=traefik \
	--write-kubeconfig-mode 644 \
	--node-ip $SERVER_IP \
	--bind-address $SERVER_IP \
	--advertise-address $SERVER_IP

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
	echo "Waiting k3s server start ..." && sleep 2
done

echo "=== Server k3s start ==="

if [ ! -d "/vagrant" ]; then
	echo "ERROR : directorie /vagrant doesn't exist. Try to create ..."
	sudo mkdir -p /vagrant
fi

K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo "$K3S_TOKEN"
echo "$K3S_TOKEN" > /vagrant/k3s-token.txt

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube

echo ""
echo "=== K3s Server install success ! ==="
if [ ! -f "/vagrant/k3s-token.txt" ]; then
	echo "Token : doesn't exist or create in k3s-token.txt"
else
	echo "Token: saved in /vagrant/k3s-token.txt"
fi
echo ""

echo "=== State cluster ==="
export KUBCONFIG=/etc/rancher/k3s/k3s.yaml
sleep 20
kubectl get nodes

echo ""
echo "=== Services k3s ==="
rc-status | grep k3s