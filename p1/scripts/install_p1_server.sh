#!/bin/sh

TOKEN=$(echo "$1" | tr -d '\r')
IP=$(echo "$2" | tr -d '\r')

if [ -z "$TOKEN" ] || [ -z "$IP" ]; then
	echo "ERREUR CRITIQUE : Le TOKEN ou l'IP est vide !"
	echo "Vérifiez votre fichier .env et votre Vagrantfile."
	exit 1
fi

echo "DEBUG: Le token utilisé est [${TOKEN}]"
# 1. Préparer Alpine Linux pour K3s
apk update
apk add curl ca-certificates iptables ip6tables coreutils util-linux
# rc-update add cgroups boot
# rc-service cgroups start

echo $TOKEN

# Au lieu de juste : export INSTALL_K3S_EXEC=...
export INSTALL_K3S_VERSION="v1.30.4+k3s1"  # Force une version qui accepte cgroups v1
export INSTALL_K3S_EXEC="server --node-ip=${IP} --advertise-address=${IP} --write-kubeconfig-mode=644"
export K3S_TOKEN=${TOKEN}

curl -sfL https://get.k3s.io | sh -

until k3s kubectl get nodes >/dev/null 2>&1; do
	echo "Waiting for K3s server..."
	sleep 2
done
# Boucle wait
echo "K3s Server started successfully!"