module "bigquery" {
  source      = "../../modules/bigquery"
  project_id  = var.project_id
  environment = "dev"
  dataset_id  = "DATA_SCNCE_DEV_DATA"
}