module "bigquery" {
  source      = "../../modules/bigquery"
  project_id  = var.project_id
  environment = "prd"
  dataset_id  = "DATA_SCNCE_DATA"
}