resource "google_artifact_registry_repository" "news_classifier" {
  project       = var.project_id
  location      = var.location
  repository_id = "news-topic-classifier"
  format        = "DOCKER"
  description   = "Docker images for news topic classifier pipeline"

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}