# Deployment Documentation

This document describes how to deploy the application in a local Kubernetes environment.

## 1. Namespace Configuration

The application is deployed within a dedicated namespace called `peek`. This helps in isolating the application resources from other apps in the cluster.

The namespace is defined in: `terraform/main.tf`

```hcl
resource "kubernetes_namespace_v1" "peek_namespace" {
  metadata {
    name = "peek"
  }
}
```

## 2. Infrastructure and App Deployment (Makefile)

The deployment is automated using a `Makefile` that handles building Docker images and applying Terraform configurations.

### Main Commands

- **`make build`**: Builds both UI and API Docker images.
- **`make run-terraform`**: Initializes Terraform, selects the workspace, and applies the Kubernetes manifests.
- **`make run-pipeline`**: Executes both `build` and `run-terraform` in sequence. This is the recommended way to deploy the entire stack.
- **`make destroy`**: Tears down the infrastructure and deletes the Terraform workspace.

To deploy everything at once, run:
```bash
make run-pipeline
```

## 3. Kubernetes Resources

Terraform automatically applies all YAML files located in `terraform/k8/`.

### Frontend Deployment
File: `terraform/k8/ui-deployment.yaml`
- **Image:** `peek-votes-ui:latest`
- **Service:** `ui-service.yaml` (Port 80)
- **Secrets:** `ui-secrets.yaml`

### Backend Deployment
File: `terraform/k8/votes-api-deployment.yaml`
- **Image:** `peek-votes-api:latest`
- **Service:** `votes-api-service.yaml` (Port 8080)
- **Secrets:** `api-secrets.yaml`

### Database
File: `terraform/k8/postgres-deployment.yaml`
- **Image:** `postgres:15-alpine`
- **Service:** `postgres-service.yaml` (Port 5432)
- **Secrets:** `postgres-secrets.yaml`

### Ingress Configuration
File: `terraform/k8/votes-ingress.yaml`
- Configures an NGINX Ingress to route traffic to the UI and API services.

## 4. Production Environment Improvements

1. Manage Secrets using an external vault (Hashicorp Vault, AWS Secrets Manager, among others)
2. Unless Node 16 is strictly required, I would recommend using the latest stable Node version
3. Implement Automated Testing. At least unit tests for the API. 80% code coverage.
4. Configure Terraform state storage securely. Versioned S3 Bucket and DynamoDB Table. 

## 5. Findings

1) UI: The API Port value is hardcoded app.js. Fixed to point to the correct port.
2) API: insert query issue: Database error: relation "vote" does not exist
LINE 1: INSERT INTO vote (id, vote) VALUES ('7gdxaxt0smle8uhd5', 'b'...
   
    The correct table name is "votes" instead of "vote"
