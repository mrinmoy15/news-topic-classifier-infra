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

output "repository_url" {
  description = "Artifact Registry repository URL"
  value       = module.artifact_registry.repository_url
}

output "vertex_ai_sa_email" {
  description = "Vertex AI service account email"
  value       = module.vertex_ai.service_account_email
}

output "hf_token_secret_id" {
  description = "HuggingFace token secret ID"
  value       = module.secret_manager.hf_token_secret_id
}

output "mlflow_tracking_url" {
  description = "MLflow tracking server URL"
  value       = module.cloud_run.service_url
}

output "mlflow_db_instance" {
  description = "Cloud SQL instance connection name for MLflow"
  value       = module.cloud_sql.instance_connection_name
}

output "mlflow_sa_email" {
  description = "MLflow Cloud Run service account email"
  value       = module.cloud_run.service_account_email
}