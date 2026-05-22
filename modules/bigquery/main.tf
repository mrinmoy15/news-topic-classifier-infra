resource "google_bigquery_dataset" "datamart" {
  project    = var.project_id
  dataset_id = var.dataset_id
  location   = var.location

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}