output "hf_token_secret_id" {
  description = "HuggingFace token secret ID"
  value       = google_secret_manager_secret.hf_token.secret_id
}

output "hf_token_secret_name" {
  description = "Full secret resource name for use in Vertex AI pipelines"
  value       = google_secret_manager_secret.hf_token.name
}