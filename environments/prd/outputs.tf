output "bigquery_dataset_id" {
  description = "BigQuery dataset ID"
  value       = module.bigquery.dataset_id
}

output "model_artifacts_bucket" {
  description = "Model artifacts bucket name"
  value       = module.cloud_storage.model_artifacts_bucket
}

output "training_data_bucket" {
  description = "Training data bucket name"
  value       = module.cloud_storage.training_data_bucket
}