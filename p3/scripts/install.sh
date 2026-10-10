#!/bin/bash

echo "=== Install Docker repository ==="

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

echo "=== Install k3d ==="

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo dnf -y install curl kubernetes-client

echo "=== Install Argo CD CLI ==="

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "Installation complete."
