# ── Model Artifacts Bucket ────────────────────────────
resource "google_storage_bucket" "model_artifacts" {
  project       = var.project_id
  name          = "${var.project_id}-model-artifacts"
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "model-artifacts"
  }
}

# ── Training Data Bucket ──────────────────────────────
resource "google_storage_bucket" "training_data" {
  project       = var.project_id
  name          = "${var.project_id}-model-data"
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "training-data"
  }
}