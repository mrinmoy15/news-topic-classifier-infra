output "service_account_email" {
  description = "Vertex AI service account email"
  value       = google_service_account.vertex_ai_sa.email
}