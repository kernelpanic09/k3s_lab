#!/bin/bash

NAMESPACE="$1"
OUTFILE="$2"

DOCKER_SERVER="478047323853.dkr.ecr.us-east-1.amazonaws.com"
DOCKER_USER="AWS"
DOCKER_PASSWORD=$(aws ecr get-login-password --region us-east-1)
DOCKER_AUTH=$(echo -n "${DOCKER_USER}:${DOCKER_PASSWORD}" | base64)

JSON="{\"auths\":{\"${DOCKER_SERVER}\":{\"username\":\"${DOCKER_USER}\",\"password\":\"${DOCKER_PASSWORD}\",\"auth\":\"${DOCKER_AUTH}\"}}}"
ENCODED_JSON=$(echo -n "${JSON}" | base64 -w 0)

cat <<EOF > "$OUTFILE"
apiVersion: v1
kind: Secret
metadata:
  name: regcred
  namespace: ${NAMESPACE}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ${ENCODED_JSON}
EOF
