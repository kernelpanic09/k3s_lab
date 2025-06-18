# 🧪 k3s Homelab

This repo documents a full-stack, production-style k3s homelab built for real-world learning, DevOps workflows, and infrastructure experimentation. It showcases GitOps with ArgoCD, CI/CD with GitHub Actions, Helm-based app deployment, and infrastructure automation using Ansible and Terraform.

---

## 📋 Overview

| Node Role     | Hostname       | K8s Version         |
|---------------|----------------|---------------------|
| Control Plane | control-plane  | v1.32.5+k3s1        |
| Worker 1      | worker-1       | v1.32.5+k3s1        |
| Worker 2      | worker-2       | v1.32.5+k3s1        |

---

## 🏠 Host Environment

- **Hypervisor**: Proxmox VE 8.4.1
- **OS**: Debian 12 (Bookworm)
- **Kernel**: 6.1.0-10-amd64
- **Networking**: Proxmox virtual bridges + Flannel (VXLAN)
- **Storage**: NFS-backed PVCs for Kubernetes, plus local disk

---

## 🔧 Platform Stack

- **Install Method**: Official k3s script
- **Runtime**: containerd
- **Ingress**: NGINX, MetalLB, cert-manager
- **Secrets**: Native K8s Secrets
- **CI/CD**: GitHub Actions + ArgoCD
- **Monitoring**: Prometheus, Grafana
- **Automation**: Ansible & Terraform

---

## 🚀 GitOps Deployment with ArgoCD

- ArgoCD bootstrapped via `bootstrap/root-app.yml`
- App definitions live in `bootstrap/apps/`
- Sync is **automated** with `prune` and `selfHeal` enabled
- Ingress and external exposure defined in `ingress/`

---

## 🔄 CI/CD Workflows

**GitHub Actions** handles CI:
- Builds Docker images
- Runs Trivy scans (optional)
- Pushes to AWS ECR
- Updates Helm values with new image tags
- Commits updated manifests to Git

**ArgoCD** handles CD:
- Watches Helm charts under `apps/*`
- Pulls latest image from ECR
- Syncs changes automatically into the k3s cluster

---

## 🧪 Applications

| App           | Location                   | Notes                              |
|---------------|----------------------------|------------------------------------|
| `demoapp`     | `apps/demoapp/`            | Flask app with Helm + GitOps flow  |
| `nginx-demo`  | `apps/nginx-demo/`         | Static NGINX app for testing       |
| `assemblyline`| `apps/assemblyline/`       | Full-scale security data platform  |

---

## 🔐 Security & Secrets

- Native K8s secrets used for minimal PoC
- Plans to test Vault/SealedSecrets later
- Ingress secured with cert-manager (Let’s Encrypt staging + prod)

---

## ⚙️ Automation

- **Ansible**: Used to bootstrap OS, install Helm, patch systems
  - All playbooks live in `ansible/playbooks/`
- **Terraform**: Cloud infrastructure as code
  - Configs in `terraform/` (modular layout in progress)

---

## 📈 Monitoring

- Prometheus + Grafana deployed via Helm
- ArgoCD dashboard exposed via NGINX ingress
- Metrics and logs stored locally (for now)

---

## 📝 Docs

- [ArgoCD Setup](docs/argocd.md)
- [Monitoring Stack](docs/monitoring.md)
- [MetalLB Setup](docs/metallb.md)
- [Static IP Config](docs/static-ip-setup.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Updates](docs/updates.md)

---

