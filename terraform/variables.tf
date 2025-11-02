variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "artifact_repo" {
  type = string
}

variable "service_name" {
  type    = string
  default = "demo"
}

variable "image" {
  type    = string
  default = ""
}

variable "env" {
  description = "Environment variables for Cloud Run"
  type        = map(string)
  default     = {}
}

variable "allow_unauthenticated" {
  type = bool
  default = true
}
