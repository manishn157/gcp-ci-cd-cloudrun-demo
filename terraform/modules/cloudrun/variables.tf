variable "project" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "service_name" {
  type = string
}

variable "image" {
  type = string
  # Default to a small public sample image so module can create a working service
  default = "gcr.io/google-samples/hello-app:1.0"
}

variable "env" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "allow_unauthenticated" {
  type = bool
  default = true
}
