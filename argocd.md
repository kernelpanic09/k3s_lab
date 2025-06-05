# ArgoCD Deployment on K3s with Traefik

## Overview

This guide documents the manual deployment of **ArgoCD** on a **K3s cluster** using **Helm** and **Traefik** as the ingress controller. Ideal for lab setups and as a baseline for transitioning to full Infrastructure as Code (IaC) via GitOps.

---

## Prerequisites

- K3s cluster with Traefik enabled (default in K3s)
- Helm installed on the control-plane node
- kubectl access to the cluster (configured `~/.kube/config`)
- `argocd.lab.local` mapped to your K3s control plane IP

---

## Step 1: Install ArgoCD via Helm

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argocd

helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.service.type=ClusterIP
```

## Step 2: Expose ArgoCD via Traefik Ingress

Create a file named argocd-ingress.yaml with the following content:

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  namespace: argocd
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
spec:
  rules:
    - host: argocd.lab.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
  tls:
    - hosts:
        - argocd.lab.local
```
Apply it:
```bash
kubectl apply -f argocd-ingress.yaml
```
## Step 3: Update Local DNS (Development Only)

Add the following entry to your /etc/hosts file on your workstation or wherever you'll access the ArgoCD UI:
```bash
192.168.1.80 argocd.lab.local
```
    Replace 192.168.1.80 with your actual K3s control plane IP.

## Step 4: Access ArgoCD

Retrieve the ArgoCD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Then access the UI at:

https://argocd.lab.local

Login with:

    Username: admin

    Password: (from the command above)

What's Next

    ✅ Connect ArgoCD to your Git repo

    ✅ Define Application resources to deploy services

    ✅ Codify your cluster's state using GitOps

Useful Commands
```bash
# See all resources in ArgoCD namespace
kubectl get all -n argocd

# Inspect ingress config
kubectl describe ingress argocd-ingress -n argocd

# Debug Traefik
kubectl logs -n kube-system -l app=traefik
```
Notes

This deployment is designed for lab/dev environments. For production use:

    Integrate TLS via cert-manager + Let's Encrypt

    Use external DNS + secure authentication (OIDC, SSO, etc.)

    Harden cluster access and secrets management