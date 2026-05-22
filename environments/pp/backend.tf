terraform {
  backend "gcs" {
    bucket = "cs-cdwp-data-pp2188-terraform-state"
    prefix = "environments/pp"
  }
}