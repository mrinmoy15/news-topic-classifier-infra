output "repository_id" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.news_classifier.repository_id
}

output "repository_url" {
  description = "Full repository URL for Docker push/pull"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/news-topic-classifier"
}