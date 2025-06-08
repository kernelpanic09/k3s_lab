#!/bin/bash
set -ex

# Install dependencies
yum update -y
yum install -y git aws-cli jq

# Fetch GitHub token from Secrets Manager
GITHUB_PAT=$(aws secretsmanager get-secret-value \
  --region ${region} \
  --secret-id example/github-pat \
  --query SecretString \
  --output text)

# Clone a private GitHub repo using the token
GIT_REPO_URL="https://${GITHUB_PAT}@github.com/your-username/your-private-repo.git"
CLONE_DIR="/opt/bootstrap-repo"

mkdir -p $CLONE_DIR
git clone $GIT_REPO_URL $CLONE_DIR

# Do something with the repo (e.g., run bootstrap script)
chmod +x $CLONE_DIR/bootstrap.sh
$CLONE_DIR/bootstrap.sh > /var/log/bootstrap-output.log 2>&1
