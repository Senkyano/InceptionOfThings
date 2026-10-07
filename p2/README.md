# PART 2

In this part2 we need to launch 3 web application with kubernetes and we can access to them with their own url or default

## Variable ENV

```bash
# PATH save vm
PATH_VM_LOAD=?

# ssh-key path
PATH_ID_RSA_PUB=?

# System config
VM_BOX=generic/alpine319
VM_VERSION_BOX=4.3.12
VM_MEMORY=1024
VM_CORE=1

VM_TAG=rihoySP2
VM_NAME=rihoySP2

VM_CORE_SERVER=2
VM_MEMORY_SERVER=2048
# Network config
IP_NODE_S=192.168.56.110

# Token server
K3S_TOKEN=?
```

````bash
# CLUSTER STATE
kubectk get pods
kubectl get nodes
kubectl get svc
kubectl get svc -n ingress-nginx

````


K3s & Kubernetes - Commandes de Débogage
Ce guide liste les commandes essentielles pour diagnostiquer le chemin complet d'une requête : Ingress -> Service -> Pod.

1. Ingress & Contrôleur (La porte d'entrée)
Vérifier que l'Ingress est bien créé et a une IP :

```Bash
kubectl get ingress
```
(L'Ingress doit avoir nginx dans la colonne CLASS et une IP attribuée).

Lire les détails de l'Ingress (et voir les erreurs en bas dans "Events") :

```Bash
kubectl describe ingress web-apps-ingress
```
Voir ce que le contrôleur Nginx fabrique (les logs en temps réel) :

```Bash
# Permet de voir les erreurs 404, 502, ou les routes introuvables
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller --tail=20
```
2. Services (Le réseau interne)
Lister tous les services et leurs IP internes :

```Bash
kubectl get svc
```
(Vérifiez que le PORT correspond bien à celui déclaré dans l'Ingress).

Vérifier que le Service trouve bien les Pods (Crucial !) :

```Bash
kubectl get endpoints
```
(Si la colonne ENDPOINTS est vide <none>, le Service ne trouve aucun Pod. Les labels du Service et du Deployment ne correspondent pas).

Tester un service directement depuis la VM (bypass de l'Ingress) :

```Bash
# Crée un tunnel temporaire sur le port 8080 de la machine
kubectl port-forward svc/service-app1 8080:80

# Dans un autre terminal, tester la connexion
curl http://localhost:8080
```
3. Pods (Vos applications)
Lister tous les Pods :

```Bash
kubectl get pods
```
Lire les logs de votre application (pour voir si le conteneur plante) :

```Bash
# Remplacer par le nom exact du pod
kubectl logs rihoy-app1-xxxxx-xxxxx
```
Entrer à l'intérieur du conteneur (comme un SSH) :

```Bash
kubectl exec -it rihoy-app1-xxxxx-xxxxx -- /bin/sh
```
4. Nettoyage & Gestion globale
Appliquer ou mettre à jour un fichier YAML :

```Bash
kubectl apply -f fichier.yaml
```
Supprimer une ressource :

```Bash
kubectl delete -f fichier.yaml
# ou spécifiquement :
kubectl delete ingress web-apps-ingress
```
Voir absolument TOUT ce qui tourne dans le namespace actuel :

```Bash
kubectl get all
```