# 🛠️ Kubernetes Homelab Update Guide

This guide documents how to safely update your k3s-based Kubernetes cluster, including the control-plane and worker nodes. It includes version checks, update commands, post-validation, and backup suggestions for clusters using the default SQLite datastore.

---

## 📦 Current Cluster Versions

- **Control Plane**: `v1.32.5+k3s1`
- **Worker Nodes**: `v1.32.5+k3s1`

---

## 🔄 Update Workflow

### 1. ✅ Pre-Update Checklist

- [ ] Review [k3s release notes](https://github.com/k3s-io/k3s/releases) for breaking changes.
- [ ] Ensure workloads are stable and backed up.
- [ ] Backup the k3s state database (see below).
- [ ] Plan a short maintenance window if needed.

---

### 2. 📦 Backup k3s SQLite State

For default single-server k3s (SQLite backend):

```bash
sudo systemctl stop k3s
sudo cp /var/lib/rancher/k3s/server/db/state.db ~/k3s-backups/state-$(date +%F).db
sudo systemctl start k3s
```

Also consider backing up your kubeconfig:
```bash
sudo cp /etc/rancher/k3s/k3s.yaml ~/k3s-backups/kubeconfig-$(date +%F).yaml
```
3. 🖥 Update the Control Plane

On the control-plane node:
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.33.x+k3s1 sh -
```
    Replace v1.33.x+k3s1 with the specific version you're upgrading to.

4. 🧑‍💻 Update Worker Nodes

On each worker node:
```bash
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_VERSION=v1.33.x+k3s1 \
  K3S_URL=https://<control-plane-ip>:6443 \
  K3S_TOKEN=<node-token> \
  sh -

    Use the original K3S_TOKEN used when first joining the cluster.
    You can retrieve it from the control-plane node:
    sudo cat /var/lib/rancher/k3s/server/node-token
```
5. 🔍 Validate the Cluster

Run the following from any node or your kubeconfig-enabled machine:
```bash
kubectl get nodes
kubectl get pods -A
kubectl version --short
```
✅ Post-Update Checklist

All nodes report the new version.

System pods in kube-system are healthy.

ArgoCD shows no sync or health issues.

Ingress and services are reachable.

    Monitoring tools (Prometheus, Grafana) are reporting normally.

💡 Notes & Best Practices

    Always update the control-plane before the workers.

    Validate your Helm releases and ArgoCD sync status after upgrade.

    If using MetalLB, check that the config map and CRs are unchanged.

    Regularly clean up old backup snapshots and stale logs.