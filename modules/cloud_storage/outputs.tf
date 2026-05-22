output "model_artifacts_bucket" {
  description = "Model artifacts bucket name"
  value       = google_storage_bucket.model_artifacts.name
}

output "training_data_bucket" {
  description = "Training data bucket name"
  value       = google_storage_bucket.training_data.name
}