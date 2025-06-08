# Kubernetes Homelab Upgrade Guide

This document outlines the process for upgrading the k3s cluster across control-plane and worker nodes.

---

## 📦 Current Versions

- Kubernetes control-plane: v1.32.5+k3s1
- Worker nodes: v1.32.5+k3s1

---

## 🔧 Upgrade Steps

1. **Control-plane upgrade**
    ```bash
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.33.x+k3s1 sh -
    ```

2. **Worker node upgrades**
    ```bash
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.33.x+k3s1 K3S_URL=https://<control-plane-ip>:6443 K3S_TOKEN=<token> sh -
    ```

3. **Verify cluster**
    ```bash
    kubectl get nodes
    kubectl version --short
    ```

---

## ✅ Post-Upgrade Checks

- All nodes show updated version.
- System pods are running and healthy.
- Application workloads continue running without issues.

---

## 📘 Notes

- Always review k3s upgrade notes and changelogs before upgrading.
- Take an etcd snapshot before control-plane upgrade.
- Upgrade control-plane **before** workers.

