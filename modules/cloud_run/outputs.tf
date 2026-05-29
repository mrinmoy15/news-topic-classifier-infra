output "service_url" {
  description = "MLflow tracking server Cloud Run URL"
  value       = google_cloud_run_v2_service.mlflow.uri
}

output "service_account_email" {
  description = "MLflow Cloud Run service account email"
  value       = google_service_account.mlflow_sa.email
}
