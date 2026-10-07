# 1. Pousser deployment.yaml et service.yaml sur le repo GitHub (public)

# 2. Déclarer l'application dans Argo CD
kubectl apply -f p3/confs/application.yaml

# 3. Vérifier
kubectl get applications -n argocd
kubectl get pods -n dev

# 4. Accéder à l'app (le Service est en ClusterIP)
kubectl port-forward svc/wil-playground -n dev 8888:8888 &
curl http://localhost:8888/