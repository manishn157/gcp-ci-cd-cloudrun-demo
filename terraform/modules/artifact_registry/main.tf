// Artifact Registry (Docker) module
resource "google_artifact_registry_repository" "docker_repo" {
  provider = google
  project  = var.project
  location = var.region
  repository_id = var.repository_id
  format = "DOCKER"
  description = var.description
}
output "repository_id" {
  value = google_artifact_registry_repository.docker_repo.repository_id
}