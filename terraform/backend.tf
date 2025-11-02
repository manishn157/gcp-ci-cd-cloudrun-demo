// Optional: configure a remote backend (GCS) for Terraform state. Uncomment
// and fill the bucket name if you want to use remote state.

/*
terraform {
  backend "gcs" {
    bucket  = "my-terraform-state-bucket"
    prefix  = "gcp-ci-cd-cloudrun-demo/terraform"
  }
}
*/
