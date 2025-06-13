# 🔐 cert-manager + Let's Encrypt DNS-01 Automation (Route 53)

This document outlines how we configure **cert-manager** to automatically issue TLS certificates using Let's Encrypt via **DNS-01 challenge** against **Amazon Route 53**. This approach enables secure HTTPS without exposing the cluster to the internet.

---

## 📦 Overview

- **cert-manager** deployed via ArgoCD
- DNS-based validation using **Route 53**
- Certificates issued by **Let's Encrypt (Staging and Production)**
- Cluster stays private — no need to open firewall or ports
- Ingress secured using automatically managed `tls.crt`/`tls.key` secrets

---

## 📁 File Structure

```text
bootstrap/platform/cert-manager/
├── cluster-issuer-prod.yaml         # ClusterIssuer using Let's Encrypt Production
├── cluster-issuer-staging.yaml      # ClusterIssuer using Let's Encrypt Staging
├── kustomization.yaml               # Kustomize manifest
└── values.yaml                      # (empty or reserved for Helm, if used)
```
## ArgoCD Applications
```bash
bootstrap/apps/
├── cert-issuer-prod.yaml
├── cert-issuer-staging.yaml
```
## ✅ Prerequisites

    Domain name (e.g. codepretzels.com)

    AWS Route 53 Hosted Zone for the domain

    An IAM user with permissions to modify Route 53 (see below)

    cert-manager deployed in cluster

    Traefik configured for HTTPS via websecure entrypoint


## 🔑 IAM Policy for Route 53 DNS-01
```bash
The following permissions are required:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetChange",
        "route53:ListResourceRecordSets",
        "route53:ChangeResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName"
      ],
      "Resource": "*"
    }
  ]
}
```
    🔐 Store the secret access key in a Kubernetes Secret (see below).

## 🔐 Secret for AWS Credentials

Do not store in Git. Create this manually:
```bash
kubectl create secret generic route53-credentials \
  --from-literal=secret-access-key=AWS_SECRET_ACCESS_KEY \
  -n cert-manager
```
    This secret is referenced by ClusterIssuer as:
```bash
secretAccessKeySecretRef:
  name: route53-credentials
  key: secret-access-key
```
🧪 Switching from Staging to Prod

Update your Ingress:
```bash
annotations:
  cert-manager.io/cluster-issuer: letsencrypt-prod
tls:
  - hosts:
      - nginx.codepretzels.com
    secretName: nginx-tls-prod
```
    cert-manager will use DNS-01 to validate and issue the certificate via Route 53.

## 🛠️ Common Troubleshooting
Issue	Fix
IssuerNotFound	Check ArgoCD sync status on ClusterIssuer app
AccessDenied	Ensure IAM policy includes all 5 Route 53 actions
Secret not found	Confirm route53-credentials secret exists
ACME client not initialized	Retry after syncing ClusterIssuer or fixing secret
rateLimited	Switch to staging, or wait ~1 hour to retry


## 🔄 Lifecycle

cert-manager automatically:

    Creates CertificateRequest

    Updates Route 53 with _acme-challenge TXT record

    Verifies challenge via Let's Encrypt

    Stores valid TLS cert in a Kubernetes Secret

    Refreshes certs before expiry (usually 30d or 90d TTL)