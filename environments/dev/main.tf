# News Topic Classifier - Dev Environment
# Managed by Terraform via GitHub Actions CI/CD
# this is for dev env

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

module "vertex_ai" {
  source      = "../../modules/vertex_ai"
  project_id  = var.project_id
  environment = "dev"
}

module "secret_manager" {
  source             = "../../modules/secret_manager"
  project_id         = var.project_id
  environment        = "dev"
  vertex_ai_sa_email = module.vertex_ai.service_account_email
}