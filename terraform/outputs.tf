output "artifact_repo" {
  value = module.artifact_repo.repository_id
}

output "cloudrun_service_name" {
  value = try(module.cloudrun_service.service_name, module.cloudrun_service.service_name)
}

output "cloudrun_service_url" {
  value = try(module.cloudrun_service.service_url, "")
}

output "gha_deployer_sa_email" {
  value = google_service_account.gha_deployer.email
  description = "Service account email for GitHub Actions deployer"
}
