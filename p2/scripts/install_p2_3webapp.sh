#!/bin/bash
echo "=== Get k3's ready ==="

until kubectl get nodes; do
	sleep 2
done

echo "=== Install nginx ingress controller ==="

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml

echo "=== Waiting ingress Nginx start ==="

kubectl wait --namespace ingress-nginx \
	--for=condition=ready pods \
	--selector=app.kubernetes.io/component=controller \
	--timeout=120s

# Patch to use port 80

echo "=== Deploying web app ... ==="

kubectl apply -f /vagrant/confs/app1.yaml
sleep 2
kubectl apply -f /vagrant/confs/app2.yaml
sleep 2
kubectl apply -f /vagrant/confs/app3.yaml

sleep 5

kubectl apply -f /vagrant/confs/ingress.yaml

echo "=== ETAT cluster ==="
kubectl get pods
kubectl get svc

kubectl patch deployment ingress-nginx-controller -n ingress-nginx --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/ports/0/hostPort",
    "value": 80
  },
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/ports/1/hostPort",
    "value": 443
  }
]'

kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx
