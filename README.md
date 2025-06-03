
# Kubernetes Homelab Setup (k3s)

This repository documents the setup, maintenance, and operations of a local Kubernetes (k3s) homelab running on Proxmox virtual machines.

---

## 🏗 Cluster Overview

| Component        | Hostname        | Role            | Kubernetes Version      |
|------------------|-----------------|-----------------|-------------------------|
| Control Plane    | control-plane   | control-plane   | v1.32.5+k3s1           |
| Worker Node 1    | worker-1        | worker          | v1.32.5+k3s1           |
| Worker Node 2    | worker-2        | worker          | v1.32.5+k3s1           |

---

## 🖥 Host Infrastructure

| Detail               | Description                         |
|----------------------|-------------------------------------|
| Hypervisor          | Proxmox VE 8.4.1                   |
| Host Machines       | 3x Virtual Machines (VMs)          |
| VM OS              | Debian GNU/Linux 12 (bookworm)      |
| Kernel             | 6.1.0-10-amd64 (SMP PREEMPT_DYNAMIC) |
| VM Resources       | (Customize per node: CPU, RAM, Disk) |
| Network Setup      | Virtualized networking via Proxmox bridges |
| Storage            | Local or shared Proxmox storage (adjust as needed) |

---

## ⚙ System Details

- **Container Runtime**: containerd (via k3s)
- **Network Plugin**: flannel (vxlan)
- **Install Method**: k3s install script

---

## 🔑 Join Token

Stored on the control-plane node:


---

## 🚀 Node Join Command

For adding a new worker:
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<control-plane-ip>:6443 K3S_TOKEN=<token> sh -
