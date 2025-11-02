# Setup guide (quick)

This document explains the minimal steps to configure GCP and GitHub so the CI/CD workflow in this repo can deploy to Cloud Run using Workload Identity Federation (OIDC) — no long-lived service account keys required.

1. Enable required GCP APIs

- Cloud Run API
- Artifact Registry API
- IAM API
- Cloud Build API (optional if using gcloud builds)

Run in Cloud Shell or locally (gcloud):

```bash
gcloud services enable run.googleapis.com artifactregistry.googleapis.com iam.googleapis.com cloudbuild.googleapis.com
```

2. Create a service account for GitHub Actions

```bash
gcloud iam service-accounts create gha-deployer --display-name "GitHub Actions Deployer"
```

Grant minimal roles to the service account (adjust as needed):

```bash
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:gha-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:gha-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"
```

3. Configure Workload Identity Federation (recommended)

- Create a Workload Identity Pool and Provider in GCP and configure GitHub as an identity provider. Follow GCP docs: https://cloud.google.com/iam/docs/workload-identity-federation

4. Add GitHub repository secrets

In your GitHub repo > Settings > Secrets > Actions, add these secrets (names used in workflow):

- `GCP_PROJECT` — your GCP project id
- `REGION` — cloud run region (e.g., us-central1)
- `ARTIFACT_REPO` — artifact registry repository id
- `WORKLOAD_IDENTITY_PROVIDER` — the provider resource name
- `GCP_SA_EMAIL` — the service account email (for setup convenience)

5. Optional: Configure Terraform backend

For team or repeated usage, configure a remote state backend (GCS bucket or Terraform Cloud). Example `backend "gcs"` block requires a GCS bucket with proper permissions.

6. Run locally

- Build and test the app locally (see README). To deploy manually, build and push an image and run `gcloud run deploy` or use Terraform module after filling variables.

Notes and security

- Do not store service account keys in GitHub Secrets. Use Workload Identity Federation instead.
- Restrict service account roles to least privilege.
- Tear down demo resources after use to avoid costs.
