# ── HuggingFace Token Secret ───────────────────────────
resource "google_secret_manager_secret" "hf_token" {
  project   = var.project_id
  secret_id = "huggingface-token"

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }

  replication {
    auto {}
  }
}

# ── Grant Vertex AI SA access to HF Token ─────────────
resource "google_secret_manager_secret_iam_member" "vertex_ai_hf_token_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.hf_token.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.vertex_ai_sa_email}"
}