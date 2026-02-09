#!/bin/bash

echo "=== Install dependecies mother VM for IoT ==="

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Installation of provider
echo "=== Installation Virtualbox Packed ==="
sudo apt-get install -y virtualbox virtualbox-ext-pack

# Vagrant packed
echo "=== Installation Vagrant Packed ==="
sudo apt-get install -y vagrant

echo ""
echo "=== Installation check ==="
echo "Virtualbox : $(vboxmanage --version)"
echo "Vagrant : $(vagrant --version)"