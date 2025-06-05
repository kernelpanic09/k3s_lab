# NGINX Demo App

## Overview

This is a simple NGINX-based demo application designed to demonstrate GitOps deployment using ArgoCD on a K3s cluster. It serves a basic static webpage via a custom `index.html` loaded from a Kubernetes `ConfigMap`.

---

## Features

- 🐳 Runs `nginx:alpine` container
- 📄 Serves a custom HTML page
- 📦 Deployed via `Deployment`, `Service`, `Ingress`, and `ConfigMap`
- 🔁 Managed entirely via ArgoCD with Kustomize
- 🌐 Exposed via Ingress using Traefik on `http://nginx.lab.local`

---

## File Structure

```text
.
├── configmap.yaml         # Contains the HTML page
├── deployment.yaml        # Deploys NGINX with volume mount
├── ingress.yaml           # Exposes the app via host-based routing
├── service.yaml           # ClusterIP service for NGINX
└── kustomization.yaml     # Kustomize config for bundling all manifests
```

## Accessing the App

Ensure this DNS mapping exists on your local machine:

```bash
192.168.1.80 nginx.lab.local
```
Replace 192.168.1.80 with your control-plane node IP.

Open a browser and navigate to:
```bash
http://nginx.lab.local
```
## ArgoCD Integration

This application is defined as an ArgoCD Application in:
```bash
bootstrap/apps/nginx-demo.yml
```
It is automatically deployed via the root-bootstrap GitOps workflow.