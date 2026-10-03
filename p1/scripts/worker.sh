#!/bin/bash

apk update && apk add curl # iptables

TOKEN="$1"

# # Attends que le serveur créé le token
# while [ ! -f "$TOKEN_FILE" ]; do
# 	echo "waiting for token"
# 	sleep 2
# done

# K3s in agent mode
curl -sfL https://get.k3s.io | \
    K3S_URL=https://192.168.56.110:6443 \
	K3S_TOKEN="$TOKEN" \
    sh -s - agent \
    --node-ip 192.168.56.111