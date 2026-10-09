#!/bin/bash

set -e

sudo dnf -y update

sudo dnf -y install \
    vim \
    make \
    gcc \
    git \
    wget

# ----------------------------------------
# Vagrant
# ----------------------------------------

echo ">>> Installation de Vagrant"

wget -qO- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo \
    | sudo tee /etc/yum.repos.d/hashicorp.repo > /dev/null
sudo dnf -y install vagrant

# ----------------------------------------
# KVM / libvirt
# ----------------------------------------

echo ">>> Installation de libvirt / KVM"

sudo dnf -y install \
    @virtualization \
    libvirt-devel

echo ">>> Activation de libvirt"

sudo systemctl enable --now libvirtd

echo ">>> Ajout de $USER au groupe libvirt"

sudo usermod -aG libvirt "$USER"

# Evite un conflit avec une éventuelle version RPM
sudo dnf remove -y --noautoremove vagrant-libvirt 2>/dev/null || true

echo ">>> Installation du plugin vagrant-libvirt"

vagrant plugin install vagrant-libvirt

echo
echo "========================================"
echo " Installation terminée"
echo "========================================"

echo
echo "Vagrant :"
vagrant --version

echo
echo "Plugins Vagrant :"
vagrant plugin list

echo
echo "Libvirt :"
virsh --version
