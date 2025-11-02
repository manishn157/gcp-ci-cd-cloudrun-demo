# Terraform usage (gcp-ci-cd-cloudrun-demo)

This Terraform directory contains modules to provision an Artifact Registry repository and a Cloud Run service. It also creates a service account (`gha-deployer`) intended for GitHub Actions and grants it the minimal roles required to push images and deploy.

Before you begin

1. Install Terraform (>= 1.0) and `gcloud` CLI.
2. Authenticate with `gcloud` and select the GCP project you want to use.

Quick commands

```bash
cd terraform
terraform init
terraform plan -var-file=envs/staging.tfvars
terraform apply -var-file=envs/staging.tfvars
```

What this will create

- Artifact Registry Docker repository (name from `artifact_repo` var)
- A Cloud Run service (if `image` var is provided, otherwise a sample public image is used)
- A service account `gha-deployer` with roles:
  - roles/artifactregistry.writer
  - roles/run.admin
  - roles/iam.serviceAccountUser

Notes

- After apply, Terraform outputs include `gha_deployer_sa_email` which you should place into GitHub Secrets as `GCP_SA_EMAIL`.
- For secure CI authentication prefer Workload Identity Federation; configure a Workload Identity Provider in GCP and add the provider resource name as `WORKLOAD_IDENTITY_PROVIDER` secret in GitHub.
- If you prefer to manage the service account and provider manually, skip the SA creation and instead configure your CI to use an existing identity.

Backend

- By default this folder uses local state. Configure `backend.tf` if you want to use a remote backend (GCS or Terraform Cloud).

Cleanup

```bash
terraform destroy -var-file=envs/staging.tfvars
```
