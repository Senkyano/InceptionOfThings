#!/bin/bash

apk update && apk add curl # iptables

TOKEN="$1"

# K3s in controller mode
curl -sfL https://get.k3s.io | \
    K3S_TOKEN="$TOKEN" \
    sh -s - server --write-kubeconfig-mode 644 \
    --node-ip 192.168.56.110 \
    --advertise-address 192.168.56.110

# -s : mode silencieux (pas de barre de progression)
# -f : échoue si le serveur renvoie une erreur
# -L : suit les redirections
# --write-kubeconfig-mode 644 : kubeconfig lisible par les utilisateurs

# Attends que K3s soit prêt
until k3s kubectl get nodes >/dev/null 2>&1; do
    echo "Waiting for K3s server..."
    sleep 2
done

# Partage le token avec le worker, mais synced_folder créé erreurs avec montage libvirt
# mkdir -p /vagrant/shared
# cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/token

# Configure kubectl pour l'utilisateur vagrant
mkdir -p /home/vagrant/.kube # Créer le dossier de config kubectl
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config # Copier le kubeconfig K3s
chown -R vagrant:vagrant /home/vagrant/.kube # Changer le propriétaire du fichier
chmod 600 /home/vagrant/.kube/config