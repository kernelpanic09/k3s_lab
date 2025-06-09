# 🚀 k3s-lab GitOps CI/CD Pipeline

This lab environment demonstrates a fully automated CI/CD workflow using **GitHub Actions**, **AWS ECR**, **ArgoCD**, **Traefik**, and **cert-manager** running on a self-hosted **k3s Kubernetes cluster**.

---

## 🔧 Stack Overview

| Tool            | Purpose                                               |
|-----------------|-------------------------------------------------------|
| **k3s**         | Lightweight Kubernetes control plane                  |
| **ArgoCD**      | GitOps continuous delivery to the k3s cluster         |
| **GitHub Actions** | CI pipeline: build/test/tag/push images to ECR     |
| **AWS ECR**     | Container image registry                              |
| **Traefik**     | Ingress controller with TLS termination               |
| **cert-manager**| Automated Let's Encrypt certificate management        |
| **MetalLB**     | LoadBalancer IP assignment for internal network apps  |

---

## 🔁 CI/CD Workflow

1. **Developer pushes code** to the `main` branch in `apps/demoapp`.
2. **GitHub Actions**:
   - Runs Python dependency install & optional tests
   - Builds and tags a Docker image
   - Pushes the image to **AWS ECR**
   - Commits the new image tag back into the Git repo (or updates via GitOps)
3. **ArgoCD detects the Git change**:
   - Syncs `apps/demoapp` Kustomize manifests
   - Updates the deployment with the new ECR image
4. **cert-manager issues a TLS cert** for `demoapp.codepretzels.com`
5. **Traefik exposes the app securely over HTTPS** via node IP and Ingress

---

## 🌐 Access

Once deployed:
- Application URL: `https://demoapp.codepretzels.com`
- TLS: Valid Let's Encrypt certificate via `cert-manager`
- Exposed via Traefik on node IP (e.g., `192.168.1.80`)

Ensure your DNS (or `/etc/hosts`) routes `demoapp.codepretzels.com` to your node IP.

---

## 🗂 Directory Structure (Key Parts)

apps/demoapp/
├── deployment.yaml # K8s Deployment pointing to ECR image
├── service.yaml # ClusterIP Service for Traefik routing
├── ingress.yaml # TLS-enabled Ingress with Traefik annotations
├── kustomization.yaml # Kustomize entrypoint for ArgoCD

.github/workflows/ci-ecr-deploy.yml # CI pipeline: test → ECR → GitOps
bootstrap/apps/demoapp.yml # ArgoCD Application definition