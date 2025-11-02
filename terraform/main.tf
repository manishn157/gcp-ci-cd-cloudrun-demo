
provider "google" {
  project = var.project
  region  = var.region
}

// Create Artifact Registry repository (docker)
module "artifact_repo" {
  source      = "./modules/artifact_registry"
  project     = var.project
  region      = var.region
  repository_id = var.artifact_repo
  description = "Docker repository for demo (created by Terraform)"
}

// Deploy a Cloud Run service. Image can be provided (for initial deployment)
module "cloudrun_service" {
  source = "./modules/cloudrun"
  project = var.project
  region  = var.region
  service_name = var.service_name
  image = var.image
  env = var.env
  allow_unauthenticated = var.allow_unauthenticated
}

// Create a service account for GitHub Actions (gha-deployer) and grant minimal roles
resource "google_service_account" "gha_deployer" {
  account_id   = "gha-deployer"
  display_name = "GitHub Actions Deployer"
  project      = var.project
}

// Grant Artifact Registry writer role
resource "google_project_iam_member" "artifact_repo_writer" {
  project = var.project
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.gha_deployer.email}"
}

// Grant Cloud Run admin role
resource "google_project_iam_member" "run_admin" {
  project = var.project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.gha_deployer.email}"
}

// Allow the service account to be impersonated (if using Workload Identity federation)
resource "google_project_iam_member" "service_account_user" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.gha_deployer.email}"
}

// Note: In many workflows you create the Artifact Registry and Service Account
// with Terraform and let CI build and push container images. The Cloud Run
// module here accepts `image` so you can deploy an existing image or leave
// empty and let CI create the service via `gcloud run deploy`.
