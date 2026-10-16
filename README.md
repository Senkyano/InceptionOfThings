# Inception of Things

This project is an introduction to Kubernetes through three parts using **Vagrant**, **K3s**, **K3d**, and **Argo CD**.

## Project overview

- **Part 1** — Create a small K3s cluster using Vagrant
- **Part 2** — Deploy and expose three web applications with K3s
- **Part 3** — Deploy an application automatically using K3d, Argo CD

## Host virtual machine

The project is developed inside a Fedora virtual machine running with **QEMU/KVM**.

The Makefile can be used to create the virtual disk, install Fedora and start the VM.

```bash
make disk
make install
make
```

The host VM can then be configured with:

```bash
./setup_host_vm.sh
```

## Part 1 — K3s and Vagrant

Create a two-node K3s cluster using Vagrant, with a K3s server and agent.

First, generate the token used by the nodes to join the cluster:

```bash
cd p1
mkdir -p confs
openssl rand -hex 32 > confs/token
```

Then start the virtual machines:

```bash
vagrant up
```

The cluster contains:

- `ahenaultS` — K3s server — `192.168.56.110`
- `ahenaultSW` — K3s agent — `192.168.56.111`

Check the cluster with:

```bash
vagrant ssh ahenaultS
kubectl get nodes -o wide
```

## Part 2 — K3s applications

Create a single K3s server and deploy three web applications.

Start the virtual machine:

```bash
cd p2
vagrant up
```

Add the application domains to `/etc/hosts`:

```bash
sudo vim /etc/hosts
```

Then add:

```text
192.168.56.110 app1.com
192.168.56.110 app2.com
192.168.56.110 app3.com
```

You can test the applications with:

```bash
curl -H "Host: app1.com" http://192.168.56.110
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: anything.com" http://192.168.56.110
```

Useful commands:

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

## Part 3 — K3d and Argo CD

Create a K3d cluster and deploy an application automatically from Git using Argo CD.

Install the required tools:

```bash
cd p3
./scripts/install.sh
```

Then create the cluster and deploy Argo CD:

```bash
./scripts/deploy.sh
```

The application is deployed in the `dev` namespace and synchronized automatically from Git.

Check the Argo CD application:

```bash
kubectl get applications -n argocd
```

Argo CD UI:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

Open:

```text
https://localhost:8080
```

Application:

```bash
kubectl port-forward -n dev svc/playground 8888:8888
curl http://localhost:8888/
```

To test GitOps, update the application image from `wil42/playground:v1`
to `wil42/playground:v2` in the Git repository and push the change.
Argo CD will automatically update the application.