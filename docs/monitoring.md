# 📊 Monitoring Stack (Prometheus + Grafana)

This lab sets up a GitOps-managed observability stack using `kube-prometheus-stack` via ArgoCD, with full TLS, dashboards, and manual CRD management to overcome Helm/ArgoCD limitations.

---

## ✅ Components

- [x] **Prometheus Operator**
- [x] **Prometheus**
- [x] **Grafana**
- [x] **Alertmanager**
- [x] TLS via Let's Encrypt (cert-manager + Traefik)

---

## 📁 Repo Structure

```text
bootstrap/
├── apps/
│   └── monitoring.yml             # ArgoCD app for kube-prometheus-stack
```

## 🛠 CRD Workaround (Required)

The Prometheus Operator Helm chart includes large CustomResourceDefinitions (CRDs) that exceed Kubernetes' annotation size limit (262,144 bytes), which causes ArgoCD sync errors.
## 🚫 Problem

metadata.annotations: Too long: may not be more than 262144 bytes

## ✅ Solution

Manually install CRDs once using server-side apply to bypass Helm + ArgoCD limitations:

# Unpack CRDs from the Helm chart
```bash
helm pull prometheus-community/kube-prometheus-stack --version 57.0.2
tar -xzf kube-prometheus-stack-57.0.2.tgz
```
## Apply CRDs using server-side apply
```bash
kubectl apply --server-side --force-conflicts -f kube-prometheus-stack/crds/
```
    Alternatively, use the upstream Prometheus Operator CRDs from the GitHub repo and trim annotations as needed.

## ✅ Helm App via ArgoCD

The ArgoCD app uses the official Helm chart and disables CRDs:

monitoring.yml
```bash
helm:
  releaseName: monitoring
  parameters:
    - name: crds.enabled
      value: "false"
  values: |
    grafana:
      ingress:
        enabled: true
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-prod
          traefik.ingress.kubernetes.io/router.entrypoints: websecure
        hosts:
          - grafana.codepretzels.com
        tls:
          - secretName: grafana-tls
            hosts:
              - grafana.codepretzels.com
      admin:
        existingSecret: grafana-admin-secret
        userKey: admin-user
        passwordKey: admin-password
```
### 🔐 TLS + Secrets

TLS is managed by cert-manager and Traefik. Grafana’s admin credentials are stored in a pre-created Kubernetes Secret:
```bash
kubectl create secret generic grafana-admin-secret \
  --from-literal=admin-user=admin \
  --from-literal=admin-password=<your-password> \
  -n monitoring
```
# 🔍 Access Grafana
```bash
URL:      https://grafana.codepretzels.com
Username: admin
Password: (from grafana-admin-secret)
```
