#!/bin/bash

# Dependency: Need to use helm to install sealed-secrets inside the kubernetes cluster
# For this local code challenge I decided to use sealed secrets
# In a production environment is best practice to use an external vault like AWS Secrets Manager, Hashicorp Vault, etc.

docker run --rm \
  --network host \
  --entrypoint /bin/sh \
  -v ~/.kube:/root/.kube \
  alpine/helm \
  -c "helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets && \
      helm repo update && \
      helm install sealed-secrets sealed-secrets/sealed-secrets -n kube-system"