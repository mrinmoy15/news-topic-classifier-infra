terraform {
  backend "gcs" {
    bucket = "cs-cdwp-data-dev2188-terraform-state"
    prefix = "environments/dev"
  }
}