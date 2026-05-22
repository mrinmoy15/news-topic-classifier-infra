module "bigquery" {
  source      = "../../modules/bigquery"
  project_id  = var.project_id
  environment = "dev"
  dataset_id  = "DATA_SCNCE_DEV_DATA"
}

module "cloud_storage" {
  source      = "../../modules/cloud_storage"
  project_id  = var.project_id
  environment = "dev"
}

module "artifact_registry" {
  source      = "../../modules/artifact_registry"
  project_id  = var.project_id
  environment = "dev"   # change per environment
}