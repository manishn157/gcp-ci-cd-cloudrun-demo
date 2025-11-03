# Terraform & IaC Guide

This guide explains the Terraform layout in this repo and provides step-by-step instructions and example commands to provision the minimal infrastructure required by the CI/CD pipeline (Artifact Registry, Cloud Run, and the GitHub Actions service account + IAM bindings). It also covers Workload Identity Federation setup so GitHub Actions can authenticate to GCP without long-lived keys.

Contents
- Repository layout and modules
- Terraform backend and state
- Variables and outputs
- Service account & IAM roles
- Workload Identity Provider (OIDC) setup (high level + gcloud commands)
- Recommended apply sequence
- Troubleshooting & tips

---

## Repo layout (Terraform)

terraform/
- modules/
  - artifact_registry/   # creates Artifact Registry Docker repo
  - cloudrun/            # creates Cloud Run service
- envs/
  - staging.tfvars       # sample variable values
  - prod.tfvars
- main.tf                # top-level wiring that calls modules and creates SA + IAM
- variables.tf           # top-level variables
- outputs.tf             # useful outputs (artifact repo id, sa email, service url)
- backend.tf             # commented example for remote backend
- versions.tf            # provider/version constraints

The modules are intentionally small and focused so you can re-use them and test individually.

## Terraform backend & state

By default the repository uses local state. For team use or repeated runs, configure a remote state backend (recommended: GCS or Terraform Cloud) to avoid conflicts and enable locking.

Example GCS backend (in `backend.tf`):

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "gcp-ci-cd-cloudrun-demo/terraform"
  }
}
```

Create the bucket and assign appropriate IAM permissions for the service account or user that will run Terraform.

## Variables and outputs

Top-level variables (see `terraform/variables.tf`) include:
- project — GCP project id
- region — GCP region (default us-central1)
- artifact_repo — Artifact Registry repo id (string)
- service_name — Cloud Run service name (default: demo)
- image — image to deploy (optional; CI will push and deploy images)
- env — list of env vars for Cloud Run
- allow_unauthenticated — boolean

Important outputs (see `terraform/outputs.tf`):
- artifact_repo
- cloudrun_service_name
- cloudrun_service_url
- gha_deployer_sa_email — service account email created for GitHub Actions

After `terraform apply`, copy `gha_deployer_sa_email` into your GitHub repository secrets as `GCP_SA_EMAIL`.

## Service account & IAM roles

The top-level Terraform creates a service account `gha-deployer` and attaches the following minimal roles:
- roles/artifactregistry.writer — allow pushing images to Artifact Registry
- roles/run.admin — allow deploying Cloud Run services
- roles/iam.serviceAccountUser — required if impersonating the SA from another identity

You can tighten scope by granting roles on specific resources rather than the whole project. For example, grant `roles/artifactregistry.writer` on the Artifact Registry repository resource.

## Workload Identity Federation (GitHub Actions OIDC)

To avoid long-lived service account keys, use Workload Identity Federation to allow GitHub Actions to impersonate the `gha-deployer` service account. High-level steps:

1. Create a Workload Identity Pool.
2. Create a Workload Identity Provider in the pool configured for GitHub as an OIDC provider.
3. Bind the provider to the GCP service account so identities from GitHub can impersonate it.

Example `gcloud` commands (replace PROJECT, POOL_NAME, PROVIDER_NAME and SA_EMAIL accordingly):

```bash
# create a pool
gcloud iam workload-identity-pools create "github-pool" \
  --project="PROJECT" --location="global" \
  --display-name="GitHub Actions Pool"

# create provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project="PROJECT" --location="global" --workload-identity-pool="github-pool" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --allowed-audiences="//iam.googleapis.com/projects/PROJECT/locations/global/workloadIdentityPools/github-pool/providers/github-provider" \
  --display-name="GitHub Provider"

# allow the provider to impersonate the service account (binding)
gcloud iam service-accounts add-iam-policy-binding "gha-deployer@PROJECT.iam.gserviceaccount.com" \
  --project="PROJECT" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/PROJECT/locations/global/workloadIdentityPools/github-pool/attribute.repository/REPO_OWNER/REPO_NAME"

gcloud.cmd iam workload-identity-pools create "github-pool-new" --project="resolute-radar-343608" --location=global --display-name="GitHub Actions Pool"

gcloud.cmd iam workload-identity-pools providers list --workload-identity-pool="github-pool-new" --location="global" --project="resolute-radar-343608"

gcloud.cmd iam service-accounts add-iam-policy-binding "gha-deployer@resolute-radar-343608.iam.gserviceaccount.com" --project="resolute-radar-343608" --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/projects/34199410565/locations/global/workloadIdentityPools/github-pool-new/attribute.repository/manishn157/gcp-ci-cd-cloudrun-demo"

```

Notes:
- The `--member` string above is a compact example; production setup often uses a broader principalSet or attribute-based member mapping. See GCP docs for exact formatting.
- You can restrict access to a single repository by using `attribute.repository/OWNER/REPO` or allow an organization by using `attribute.repository/ORG/*`.

After setting up the provider, record the provider resource name and put it into GitHub Secrets as `WORKLOAD_IDENTITY_PROVIDER` (the full resource path is required by the GitHub Actions `google-github-actions/auth` action).

## Example: Run Terraform (recommended sequence)

1. Initialize Terraform

```bash
cd terraform
terraform init
```

2. Plan using the sample staging variables

```bash
terraform plan -var-file=envs/staging.tfvars
```

3. Apply

```bash
terraform apply -var-file=envs/staging.tfvars
```

4. After apply, note outputs:

```bash
terraform output gha_deployer_sa_email
terraform output artifact_repo
terraform output cloudrun_service_url
```

Add `gha_deployer_sa_email` to GitHub Secrets as `GCP_SA_EMAIL` and set other required secrets (`GCP_PROJECT`, `REGION`, `ARTIFACT_REPO`, `WORKLOAD_IDENTITY_PROVIDER`).

## Optional: Automate provider creation with Terraform

Workload Identity Pool/Provider resources can be created with Terraform using the `google_iam_workload_identity_pool` and `google_iam_workload_identity_pool_provider` resources. This is possible but a little more advanced because you will need to ensure proper labelling and the exact `attribute` mapping for GitHub repositories. If you want, we can add a Terraform module to create the provider and bind it.

## Troubleshooting & tips

- If `gcloud builds submit` fails to push, verify the Artifact Registry repo exists and the service account has `artifactregistry.writer`.
- If `gcloud run deploy` fails with permission denied, ensure the impersonating identity (service account) has `roles/run.admin`.
- Use `gcloud projects get-iam-policy PROJECT` to inspect current IAM bindings.
- Use `terraform state list` and `terraform output` to inspect created resources after a successful apply.

## Security considerations

- Prefer Workload Identity Federation over static service account keys.
- Grant least privilege: scope roles to resources and avoid project-level bindings if possible.
- Rotate and remove unused service accounts and IAM bindings.

---

If you'd like, I can:
- Add a Terraform module that creates the Workload Identity Pool & Provider and binds it to `gha-deployer`, or
- Add example Terraform IAM bindings scoped to the artifact registry resource instead of project-level bindings.

Tell me which one to do next and I'll implement it.
