#!/bin/bash

cd "$(dirname "$0")"

echo "=== Create k3d cluster ==="

if ! k3d cluster list | grep -q "^iot "; then
    k3d cluster create iot
else
    echo "Cluster 'iot' exists already, skipping creation."
fi

echo "=== Create namespaces ==="

kubectl get namespace dev >/dev/null 2>&1 || kubectl create namespace dev
kubectl get namespace argocd >/dev/null 2>&1 || kubectl create namespace argocd

echo "=== Install Argo CD ==="

kubectl apply --server-side --force-conflicts \
    -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Available deployments --all \
    -n argocd \
    --timeout=600s

echo "=== Create Argo CD application ==="

kubectl apply -f "../application.yaml"

echo "=== Done ==="

echo "Admin password :"
kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath='{.data.password}' | base64 -d; echo

echo
echo "Argo CD UI:"
echo "kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo "-> https://localhost:8080/"

echo
echo "Application:"
echo "kubectl port-forward -n dev svc/playground 8888:8888"
echo "-> curl http://localhost:8888/"