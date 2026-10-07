#!/bin/sh

TOKEN=$1
SERVER_IP=$2

echo "Préparation de Alpine Linux pour K3s (Worker)..."
apk update
apk add curl ca-certificates iptables ip6tables coreutils util-linux

echo "Installation de K3s Agent..."
# Le fait de définir K3S_URL indique à l'installateur qu'il doit configurer un "agent" (worker)
export INSTALL_K3S_VERSION="v1.30.4+k3s1"
export K3S_URL="agent https://${SERVER_IP}:6443"
export K3S_TOKEN=${TOKEN}

curl -sfL https://get.k3s.io | sh -

echo "Worker connecté au serveur K3s avec succès !"