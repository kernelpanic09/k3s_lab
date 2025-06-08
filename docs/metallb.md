# MetalLB GitOps Deployment

This directory contains the GitOps-managed configuration for deploying MetalLB, a load balancer implementation for bare-metal Kubernetes clusters, using Argo CD.

---

## 🧱 Architecture

The MetalLB deployment is split into logical GitOps apps to ensure clean separation of concerns and controlled synchronization order.

### 🔹 Apps

| App Name       | Description                                     | Sync Wave |
|----------------|--------------------------------------------------|------------|
| `metallb-crds` | Installs MetalLB's Custom Resource Definitions (CRDs) and controllers. Also includes the `metallb-system` namespace. | 1 |
| `metallb`      | Deploys cluster-specific MetalLB configuration such as IP pools and advertisements. | 2 |

---

## 🗂️ Directory Structure

```text
bootstrap/
└── platform/
    ├── metallb/
    │   ├── config/
    │   │   └── metallb-config.yaml        # IPAddressPool & L2Advertisement
    │   └── kustomization.yaml             # references config
    └── metallb-crds/
        ├── namespace.yaml                 # Creates metallb-system
        ├── metallb-crds.yaml              # Official MetalLB manifest
        └── kustomization.yaml

⚙️ Configuration
🧩 IPAddressPool (config/metallb-config.yaml)

apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: codepretzels-pool
  namespace: metallb-system
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  addresses:
    - 192.168.1.20-192.168.1.30

🔊 L2Advertisement

apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
  annotations:
    argocd.argoproj.io/sync-wave: "2"

🚀 How It Works with Argo CD

    metallb-crds deploys the metallb-system namespace and all CRDs and controllers needed for MetalLB.

    metallb waits for the CRDs to be installed and then applies the configuration.

    Sync waves ensure strict ordering between CRDs and CRs, eliminating race conditions.

🧪 Validation

Run these to confirm everything is live:

# Check MetalLB pods
kubectl get pods -n metallb-system

# Confirm CRDs
kubectl get crd | grep metallb

# Confirm IP pool applied
kubectl get ipaddresspool -n metallb-system

