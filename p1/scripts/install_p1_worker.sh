#!/bin/bash

echo "=== Install dependecies Worker ==="

apk update && apk upgrade
apk add -no-cahce curl openssh-client

TOKEN=$1
SERVER_IP=$2

curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 \
	K3S_TOKEN=$TOKEN sh -
