# Kubernetes Homelab Troubleshooting Guide

This document logs common issues encountered in the homelab and the solutions applied.

---

## 🛑 Common Issues

### Issue: Node NotReady
- **Symptoms**:
    - `kubectl get nodes` shows NotReady
    - Logs show `Kubelet stopped posting node status`
- **Fix**:
    - SSH into node, check k3s service:
        ```bash
        systemctl status k3s / k3s-agent
        journalctl -u k3s -n 50
        ```
    - Restart service:
        ```bash
        systemctl restart k3s / k3s-agent
        ```

---

### Issue: Unable to resolve host
- **Symptoms**:
    - `sudo: unable to resolve host <hostname>`
- **Fix**:
    - Update `/etc/hosts` to include:
        ```
        127.0.1.1   <hostname>
        ```

---

### Issue: Version mismatch between control-plane and workers
- **Symptoms**:
    - `kubectl get nodes` shows mixed Kubernetes versions
- **Fix**:
    - Upgrade control-plane and workers to match:
        ```bash
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=<desired_version> sh -
        ```

---

## 📘 Logging Useful Commands

- View all pods:
    ```bash
    kubectl get pods -A
    ```

- Describe a node:
    ```bash
    kubectl describe node <node>
    ```

- Check etcd snapshots:
    ```bash
    k3s etcd-snapshot ls
    ```

- Restore etcd:
    ```bash
    k3s etcd-snapshot restore --name <snapshot>
    ```

---

## 📌 Notes

- Always log fixes here to build your personal playbook.
- Update regularly to capture new issues and learnings.

