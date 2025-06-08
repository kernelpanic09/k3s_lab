# AWS EC2 Bootstrap with Secrets Manager Integration

## 🧰 Overview

This Terraform project demonstrates how to securely bootstrap an EC2 instance using AWS Secrets Manager and EC2 IAM roles. The automation leverages **user data** to:

- Install required packages on launch.
- Retrieve a **GitHub Personal Access Token (PAT)** from AWS Secrets Manager.
- Clone a **private GitHub repository** using that token.
- Run a bootstrap script from the cloned repo to configure the instance.

This is a practical pattern used in real-world DevOps to automate infrastructure provisioning securely and reproducibly.

---

## 🔐 Key Concepts

- **IAM Role for EC2**: Grants permission to retrieve secrets without storing credentials in plaintext.
- **Secrets Manager**: Secure store for sensitive values like GitHub PATs, database credentials, or API keys.
- **User Data**: Executes automation at instance launch, ideal for bootstrap tasks.
- **SSM Integration**: Enables secure remote management of the instance without public access.

---

## 📁 Files

- `main.tf`: Terraform script to provision VPC, IAM roles, EC2 instance, and VPC endpoints.
- `user-data.tpl`: Template for the EC2 user data script that installs packages, retrieves a secret, and runs a repo script.
- `variables.tf`: Contains the region and other configurable options.

---

## 🚀 How It Works

1. Terraform provisions:
   - A VPC with public and private subnets.
   - An EC2 instance with an IAM role.
   - VPC endpoints for Secrets Manager and SSM.
2. On launch, the EC2 instance:
   - Uses `aws-cli` to securely pull a secret (GitHub PAT).
   - Clones a private GitHub repo using that PAT.
   - Executes a script from the repo (e.g., `bootstrap.sh`).
3. Logs output to `/var/log/bootstrap-output.log`.

---

## 🔄 Example Secret (in AWS Secrets Manager)

Secret name: `example/github-pat`  
Secret value (example):
```json
ghp_1234567890abcdef1234567890abcdef12345678
