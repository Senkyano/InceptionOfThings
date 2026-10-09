#!/bin/bash

echo "=== Install dependecies mother VM for IoT ==="

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Docker installation ( Part3 )
echo "=== Installation docker ==="
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install K3s
echo "=== Installation kubectl ==="
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#Install K3d
echo "Installation de K3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo ""
echo "=== Installation check ==="
echo "Docker : $(docker --version)"
echo "kubectl : $(kubectl version --client --short 2>/dev/null)"
echo "k3d : $(k3d version)"