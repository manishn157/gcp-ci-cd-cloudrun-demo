// Cloud Run module - creates a Cloud Run service using a given container image
// Usage: call this module with service_name and image

resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = 8080
        }
        dynamic "env" {
          for_each = var.env
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }
}

// Allow unauthenticated (optional; control via variable)
resource "google_cloud_run_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  service  = google_cloud_run_service.service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
