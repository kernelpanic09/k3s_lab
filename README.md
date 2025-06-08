# 🧪 Kubernetes Homelab (k3s_lab)

This repository documents the deployment, management, and automation of a production-style Kubernetes (k3s) homelab environment. It's built for learning, showcasing DevOps practices, and running real workloads using tools like ArgoCD, GitHub Actions, Helm, and ECR.

---

## 📚 Table of Contents

- [Cluster Overview](#cluster-overview)
- [Host Infrastructure](#host-infrastructure)
- [System Details](#system-details)
- [GitOps Deployment](#gitops-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Provisioning & Automation](#provisioning--automation)
- [Apps Deployed](#apps-deployed)
- [Monitoring & Observability](#monitoring--observability)
- [Documentation](#documentation)
- [Joining New Nodes](#joining-new-nodes)

---

## 🏗 Cluster Overview

| Component      | Hostname       | Role           | Kubernetes Version    |
|----------------|----------------|----------------|------------------------|
| Control Plane  | control-plane  | control-plane  | v1.32.5+k3s1           |
| Worker Node 1  | worker-1       | worker         | v1.32.5+k3s1           |
| Worker Node 2  | worker-2       | worker         | v1.32.5+k3s1           |

---

## 🖥 Host Infrastructure

| Detail         | Description                            |
|----------------|----------------------------------------|
| Hypervisor     | Proxmox VE 8.4.1                       |
| VM OS          | Debian GNU/Linux 12 (bookworm)         |
| Kernel         | 6.1.0-10-amd64 SMP PREEMPT_DYNAMIC     |
| Networking     | Proxmox virtual bridges (vxlan/flannel)|
| Storage        | Local/shared Proxmox storage           |

---

## ⚙ System Details

- **Install**: via official [k3s install script](https://rancher.com/docs/k3s/latest/en/installation/)
- **Container Runtime**: containerd
- **Network Plugin**: flannel (vxlan)
- **Ingress**: NGINX + MetalLB + cert-manager
- **Storage**: NFS (manual PVC + test pod), longhorn planned
- **Secrets**: Native K8s Secrets + Sealed Secrets (in progress)

---

## 🚀 GitOps Deployment

- **ArgoCD** is used for GitOps-style continuous delivery
- ArgoCD is deployed via Helm and configured using `bootstrap/root-app.yml`
- All apps and platform components are defined under `bootstrap/apps/`
- Sync policies are set to `automated` with `prune` and `selfHeal`

---

## ⚙️ CI/CD Pipeline

- **CI**: GitHub Actions (`.github/workflows/ci-ecr-deploy.yml`)
  - Builds app Docker images
  - Scans with Trivy (optional)
  - Pushes to ECR
  - Patches Helm `values.yaml` with image tag
  - Commits back to Git for ArgoCD to detect

- **CD**: ArgoCD
  - Watches `apps/*/helm-chart`
  - Pulls latest image from ECR using patched Helm values
  - Deploys into k3s via sync

### Demo App Pipeline:
- App: `apps/demoapp`
- Helm chart: `apps/demoapp/helm-chart`
- ECR repo: `demoapp`
- Deployment triggered by GitHub push

---

## 🛠 Provisioning & Automation

- **Ansible**: All k3s nodes are bootstrapped using `ansible/playbooks/`
  - Install tools, patch OS, setup MOTD
  - Install Helm and prepare environment
- **Terraform**: Reserved for cloud provisioning, under `terraform/`
- **Makefiles (planned)**: Wrapper scripts for bootstrap and testing flows

---

## 🧩 Apps Deployed

| App            | Source                                | Notes                              |
|----------------|----------------------------------------|------------------------------------|
| demoapp        | `apps/demoapp/`                        | Flask test app with CI/CD pipeline |
| nginx-demo     | `apps/nginx-demo/`                     | Simple static NGINX test app       |
| assemblyline   | `apps/assemblyline/`                   | Complex security data platform     |

---

## 📈 Monitoring & Observability

- [Prometheus & Grafana](docs/monitoring.md) deployed via Helm
- ArgoCD UI exposed via [Ingress](ingress/argocd-ingress.yaml)
- Future integrations: alerting to Slack/webhook

---

## 📖 Documentation

- [ArgoCD Setup](docs/argocd.md)
- [Monitoring Stack](docs/monitoring.md)
- [MetalLB Configuration](docs/metallb.md)
- [Static IP Setup](docs/static-ip-setup.md)
- [Upgrade Notes](docs/upgrade.md)
- [Troubleshooting](docs/troubleshooting.md)

---

## ➕ Joining New Nodes

To join a new worker node to the cluster:

```bash
curl -sfL https://get.k3s.io | \
  K3S_URL=https://<control-plane-ip>:6443 \
  K3S_TOKEN=<join-token> \
  sh -
