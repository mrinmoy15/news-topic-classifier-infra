terraform {
  backend "gcs" {
    bucket = "cs-cdwp-data-prd2188-terraform-state"
    prefix = "environments/prd"
  }
}