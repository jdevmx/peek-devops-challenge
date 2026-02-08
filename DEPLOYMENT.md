# Deployment Documentation

This document describes how to deploy the application in a local Kubernetes environment.

## 1. Namespace Configuration

The application is deployed within a dedicated namespace called `peek`. This helps in isolating the application resources from other apps in the cluster.

The namespace is defined in: `terraform/k8/namespace.yaml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: peek
```

## 2. Secrets Management

For security best practices, sensitive information such as environment variables for the UI are encrypted using **Sealed Secrets**.

### Setup Sealed Secrets Controller

Before applying deployment, you need the Sealed Secrets controller installed in your cluster. You can use the provided script:

```bash
./local-env/set-k8.sh
```

This script uses Helm to install the `sealed-secrets` controller into the `kube-system` namespace.

## 3. Frontend Deployment

The frontend of the application is defined as a Kubernetes Deployment. It manages the lifecycle of the UI containers.

File: `terraform/k8/frontend.yaml`

### Key Components

- **Replicas:** Set to `1` by default for local environment.
- **Image:** Uses `peek-frontend:latest`.
- **Environment Variables:** The deployment consumes secrets from the `votes-ui-secrets` Secret (which is decrypted from the `SealedSecret`).

The following environment variables are injected into the container:
- `PORT`: The port the UI server
- `VOTES_API_HOST`: The host address of the backend API
- `VOTES_API_PORT`: The port of the backend API

### 4. Backend Deployment

#### TODO: Add backend deployment

### 5. Ingress Configuration

#### TODO: Add ingress configuration

### 6. Production Environment Improvements

1. Manage Secrets using an external vault (Hashicorp Vault, AWS Secrets Manager, among others)
2. Unless Node 16 is strictly required, I would recommend using the latest stable Node version

### Applying the Deployment

#### TODO: Add deployment commands using IaC ( Terraform )
