#!/bin/sh
# Usage: install_p1_worker.sh <TOKEN> <SERVER_IP> <WORKER_IP>

K3S_TOKEN="$1"
SERVER_IP="$2"
WORKER_IP="$3"

if [ -z "$K3S_TOKEN" ] || [ -z "$SERVER_IP" ] || [ -z "$WORKER_IP" ]; then
	echo "Usage: $0 <TOKEN> <SERVER_IP> <WORKER_IP>"
	exit 1
fi

echo "=== Dépendances (worker) ==="
apk update
apk add --no-cache curl

# K3s a besoin des cgroups sur Alpine
rc-update add cgroups default 2>/dev/null
rc-service cgroups start 2>/dev/null

echo "=== Attente du server K3s (${SERVER_IP}:6443) ==="
COUNT=0
until curl -sk "https://${SERVER_IP}:6443" >/dev/null 2>&1; do
	COUNT=$((COUNT + 1))
	if [ "$COUNT" -ge 60 ]; then
		echo "Timeout: le server K3s ne répond pas"
		exit 1
	fi
	echo "Attente du server... (${COUNT}/60)"
	sleep 5
done

echo "=== Installation de K3s en mode agent ==="
curl -sfL https://get.k3s.io | \
	K3S_URL="https://${SERVER_IP}:6443" \
	K3S_TOKEN="K10bb2b3b950ea19944e9eca2612df820e605f491865f56b2c5f06579da4e11b61f::server:d25bff03bfddc749c669605315cb742d" \
	sh -s - agent \
	--node-ip "${WORKER_IP}" \
	--flannel-iface eth1

echo "Worker connecté au server !"
rc-service k3s-agent status