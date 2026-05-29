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

module "cloud_sql" {
  source        = "../../modules/cloud_sql"
  project_id    = var.project_id
  environment   = "dev"
  database_tier = "db-f1-micro"
}

module "cloud_run" {
  source                       = "../../modules/cloud_run"
  project_id                   = var.project_id
  environment                  = "dev"
  mlflow_image                 = var.mlflow_image
  artifact_bucket              = module.cloud_storage.model_artifacts_bucket
  sql_instance_connection_name = module.cloud_sql.instance_connection_name
  db_name                      = module.cloud_sql.database_name
  db_user                      = module.cloud_sql.user_name
  db_password_secret_id        = module.cloud_sql.password_secret_id
  vertex_ai_sa_email           = module.vertex_ai.service_account_email
}