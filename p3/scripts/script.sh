#!/bin/bash

set -e

echo "=== Create k3d cluster ==="

sudo k3d cluster create iot

echo "=== Create namespaces ==="

sudo kubectl create namespace dev
sudo kubectl create namespace argocd

echo "=== Install Argo CD ==="

sudo kubectl apply --server-side --force-conflicts \
    -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl wait \
    --for=condition=Available \
    deployment/argocd-server \
    -n argocd \
    --timeout=300

echo "=== Create Argo CD application ==="

sudo kubectl apply -f application.yaml

echo "=== Done ==="

echo "Mot de passe admin :"
kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath='{.data.password}' | base64 -d; echo
