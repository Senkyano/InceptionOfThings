#!/bin/sh

TOKEN=$(echo "$1" | tr -d '\r')
SERVER_IP=$(echo "$2" | tr -d '\r')

echo "Préparation de Alpine Linux pour K3s (Worker)..."
apk update
apk add curl ca-certificates iptables ip6tables coreutils util-linux

rc-update add cgroups boot
rc-service cgroups start

echo "Installation de K3s Agent..."
# Le fait de définir K3S_URL indique à l'installateur qu'il doit configurer un "agent" (worker)
export INSTALL_K3S_VERSION="v1.30.4+k3s1"
export K3S_URL="https://${SERVER_IP}:6443"
export K3S_TOKEN=${TOKEN}

curl -sfL https://get.k3s.io | sh -

echo "Worker connecté au serveur K3s avec succès !"