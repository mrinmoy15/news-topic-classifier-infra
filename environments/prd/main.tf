module "bigquery" {
  source      = "../../modules/bigquery"
  project_id  = var.project_id
  environment = "prd"
  dataset_id  = "DATA_SCNCE_DATA"
}

module "cloud_storage" {
  source      = "../../modules/cloud_storage"
  project_id  = var.project_id
  environment = "prd"
}

module "artifact_registry" {
  source      = "../../modules/artifact_registry"
  project_id  = var.project_id
  environment = "prd"
}

module "vertex_ai" {
  source      = "../../modules/vertex_ai"
  project_id  = var.project_id
  environment = "prd"
}

module "secret_manager" {
  source             = "../../modules/secret_manager"
  project_id         = var.project_id
  environment        = "prd"
  vertex_ai_sa_email = module.vertex_ai.service_account_email
}