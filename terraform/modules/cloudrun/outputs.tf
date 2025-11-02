output "service_name" {
  value = google_cloud_run_service.service.name
}

output "service_url" {
  value = google_cloud_run_service.service.status[0].url
}
