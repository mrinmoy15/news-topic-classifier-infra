# News Topic Classifier — Infrastructure

Terraform infrastructure for the News Topic Classifier pipeline, deployed across three GCP environments (dev, pre-prod, production).

## Repository Structure

```
.
├── bootstrap/          # One-time bootstrap: WIF, GitHub SA, state buckets
├── docker/
│   └── mlflow/         # Dockerfile for MLflow tracking server
├── environments/
│   ├── dev/            # Development environment
│   ├── pp/             # Pre-production environment
│   └── prd/            # Production environment
└── modules/
    ├── artifact_registry/
    ├── bigquery/
    ├── cloud_run/       # MLflow tracking server (Cloud Run + IAM)
    ├── cloud_sql/       # MLflow backend store (PostgreSQL)
    ├── cloud_storage/
    ├── secret_manager/
    └── vertex_ai/
```

## GCP Projects

| Environment  | Project ID              |
|-------------|--------------------------|
| Development  | `cs-cdwp-data-dev2188`  |
| Pre-Prod     | `cs-cdwp-data-pp2188`   |
| Production   | `cs-cdwp-data-prd2188`  |

---

## Architecture

```
Vertex AI Pipeline
       │
       ▼ logs metrics
MLflow Tracking Server (Cloud Run)
       │                    │
       ▼                    ▼
Cloud SQL (PostgreSQL)    GCS (artifacts)
  run metadata             model files
```

---

## Deployment Order

Run these steps once before the first `terraform apply`:

### 1. Bootstrap (one-time)
```bash
make apply-bootstrap
```
Creates the GitHub Actions SA, Workload Identity Federation, Terraform state buckets, and enables all required APIs across all three projects.

### 2. Build and push the MLflow Docker image
```bash
make mlflow-auth        # configure Docker to push to Artifact Registry
make mlflow-push-all    # build once, push to dev / pp / prd registries
```

### 3. Set GitHub Actions variables

Go to **GitHub repo → Settings → Secrets and variables → Actions → Variables** and add:

| Variable | Value |
|---|---|
| `DEV_MLFLOW_IMAGE` | `us-central1-docker.pkg.dev/cs-cdwp-data-dev2188/news-topic-classifier/mlflow:latest` |
| `PP_MLFLOW_IMAGE`  | `us-central1-docker.pkg.dev/cs-cdwp-data-pp2188/news-topic-classifier/mlflow:latest`  |
| `PRD_MLFLOW_IMAGE` | `us-central1-docker.pkg.dev/cs-cdwp-data-prd2188/news-topic-classifier/mlflow:latest` |
| `DEV_PROJECT_ID`   | `cs-cdwp-data-dev2188` |

### 4. Apply environments in order
```bash
make init-all

make plan-dev && make apply-dev
make plan-pp  && make apply-pp
make plan-prd && make apply-prd
```

Get the MLflow URL for each environment after apply:
```bash
cd environments/dev && terraform output mlflow_tracking_url
cd environments/pp  && terraform output mlflow_tracking_url
cd environments/prd && terraform output mlflow_tracking_url
```

---

## GCP Resources

### CI/CD — Bootstrap (one-time, dev project only)

| Resource Type | Name / ID |
|---|---|
| Service Account | `github-actions-sa@cs-cdwp-data-dev2188.iam.gserviceaccount.com` |
| Workload Identity Pool | `github-pool` (project `cs-cdwp-data-dev2188`) |
| Workload Identity Provider | `github-provider` (issuer: `token.actions.githubusercontent.com`) |

**Workload Identity Provider full resource name:**
```
projects/74788655295/locations/global/workloadIdentityPools/github-pool/providers/github-provider
```

### Terraform State Buckets (one per project)

| Environment | Bucket Name |
|---|---|
| Development  | `cs-cdwp-data-dev2188-terraform-state` |
| Pre-Prod     | `cs-cdwp-data-pp2188-terraform-state`  |
| Production   | `cs-cdwp-data-prd2188-terraform-state` |

> Versioning enabled, uniform bucket-level access, location: US.

### Artifact Registry

| Environment | Repository | Location | Format |
|---|---|---|---|
| Development  | `news-topic-classifier` | `us-central1` | Docker |
| Pre-Prod     | `news-topic-classifier` | `us-central1` | Docker |
| Production   | `news-topic-classifier` | `us-central1` | Docker |

### Cloud Storage Buckets

| Environment | Purpose | Bucket Name |
|---|---|---|
| Development  | Model Artifacts | `cs-cdwp-data-dev2188-model-artifacts` |
| Development  | Training Data   | `cs-cdwp-data-dev2188-model-data`      |
| Pre-Prod     | Model Artifacts | `cs-cdwp-data-pp2188-model-artifacts`  |
| Pre-Prod     | Training Data   | `cs-cdwp-data-pp2188-model-data`       |
| Production   | Model Artifacts | `cs-cdwp-data-prd2188-model-artifacts` |
| Production   | Training Data   | `cs-cdwp-data-prd2188-model-data`      |

> Versioning enabled, uniform bucket-level access, location: US.

### BigQuery Datasets

| Environment | Dataset ID |
|---|---|
| Development  | `DATA_SCNCE_DEV_DATA` |
| Pre-Prod     | `DATA_SCNCE_DEV_DATA` |
| Production   | `DATA_SCNCE_DATA`     |

### Secret Manager

| Environment | Secret ID | Description |
|---|---|---|
| Development  | `huggingface-token`  | HuggingFace API token for Vertex AI |
| Pre-Prod     | `huggingface-token`  | HuggingFace API token for Vertex AI |
| Production   | `huggingface-token`  | HuggingFace API token for Vertex AI |
| Development  | `mlflow-db-password` | MLflow PostgreSQL user password |
| Pre-Prod     | `mlflow-db-password` | MLflow PostgreSQL user password |
| Production   | `mlflow-db-password` | MLflow PostgreSQL user password |

### Service Accounts

| SA | Environment | Email |
|---|---|---|
| Vertex AI | dev | `vertex-ai-sa@cs-cdwp-data-dev2188.iam.gserviceaccount.com` |
| Vertex AI | pp  | `vertex-ai-sa@cs-cdwp-data-pp2188.iam.gserviceaccount.com`  |
| Vertex AI | prd | `vertex-ai-sa@cs-cdwp-data-prd2188.iam.gserviceaccount.com` |
| MLflow    | dev | `mlflow-sa@cs-cdwp-data-dev2188.iam.gserviceaccount.com`    |
| MLflow    | pp  | `mlflow-sa@cs-cdwp-data-pp2188.iam.gserviceaccount.com`     |
| MLflow    | prd | `mlflow-sa@cs-cdwp-data-prd2188.iam.gserviceaccount.com`    |

**Vertex AI SA roles:**
- `roles/aiplatform.user`
- `roles/bigquery.dataEditor`
- `roles/bigquery.jobUser`
- `roles/storage.objectAdmin`
- `roles/artifactregistry.reader`
- `roles/run.invoker` on `mlflow-tracking-server`

**MLflow SA roles:**
- `roles/cloudsql.client`
- `roles/storage.objectAdmin`
- `roles/secretmanager.secretAccessor` on `mlflow-db-password`

### MLflow Tracking Server

| Resource | Details |
|---|---|
| Cloud Run service | `mlflow-tracking-server` (`us-central1`) |
| Cloud SQL instance | `{project_id}-mlflow` — PostgreSQL 15 |
| Database / User | `mlflow` / `mlflow` |
| DB password secret | `mlflow-db-password` (Secret Manager) |
| Artifact root | `gs://{project_id}-model-artifacts/mlflow-artifacts` |

**Database tiers per environment:**

| Environment | Tier | RAM | Deletion protection |
|---|---|---|---|
| dev | `db-f1-micro`      | 0.6 GB | false |
| pp  | `db-g1-small`      | 1.7 GB | false |
| prd | `db-custom-2-7680` | 7.5 GB | true  |

### Enabled APIs (all three projects)

| API |
|---|
| `iam.googleapis.com` |
| `cloudresourcemanager.googleapis.com` |
| `iamcredentials.googleapis.com` |
| `sts.googleapis.com` |
| `bigquery.googleapis.com` |
| `storage.googleapis.com` |
| `artifactregistry.googleapis.com` |
| `aiplatform.googleapis.com` |
| `run.googleapis.com` |
| `cloudscheduler.googleapis.com` |
| `secretmanager.googleapis.com` |
| `sqladmin.googleapis.com` |

---

## MLflow Docker Image

The MLflow image is built from `docker/mlflow/Dockerfile` and includes:
- `mlflow[gcs]` — MLflow with Google Cloud Storage artifact support
- `psycopg2-binary` — PostgreSQL driver for the Cloud SQL backend store

**Makefile commands:**

| Command | Description |
|---|---|
| `make mlflow-auth` | Authenticate Docker to Artifact Registry |
| `make mlflow-build` | Build the image locally |
| `make mlflow-push-dev` | Build and push to dev registry |
| `make mlflow-push-pp` | Tag and push to pp registry |
| `make mlflow-push-prd` | Tag and push to prd registry |
| `make mlflow-push-all` | Push to all three registries |

To upgrade MLflow, edit the version pin in `docker/mlflow/Dockerfile` and re-run `make mlflow-push-all`.

---

## Using MLflow from a Vertex AI Pipeline

The Cloud Run service requires IAM authentication. Use a GCP ID token via the `MLFLOW_TRACKING_TOKEN` environment variable, which MLflow sends automatically as a `Bearer` header:

```python
import os
import mlflow
import google.auth
import google.auth.transport.requests
from google.auth.transport.requests import AuthorizedSession
from google.oauth2 import id_token

MLFLOW_URL = "<value of terraform output mlflow_tracking_url>"

auth_req = google.auth.transport.requests.Request()
token = id_token.fetch_id_token(auth_req, MLFLOW_URL)

os.environ["MLFLOW_TRACKING_TOKEN"] = token
mlflow.set_tracking_uri(MLFLOW_URL)
mlflow.set_experiment("news-topic-classifier")
```

The `vertex-ai-sa` already has `roles/run.invoker` so no additional IAM setup is needed in the pipeline.

---

## GitHub Actions Credentials

```
service_account_email =
"github-actions-sa@cs-cdwp-data-dev2188.iam.gserviceaccount.com"

workload_identity_provider =
"projects/74788655295/locations/global/workloadIdentityPools/github-pool/providers/github-provider"
```
