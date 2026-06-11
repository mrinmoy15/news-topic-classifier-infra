# ── Vertex AI Service Account ─────────────────────────
resource "google_service_account" "vertex_ai_sa" {
  project      = var.project_id
  account_id   = "vertex-ai-sa"
  display_name = "Vertex AI Service Account"
  description  = "Service account for Vertex AI pipeline runs"
}

# ── Grant Vertex AI SA permissions ────────────────────
resource "google_project_iam_member" "vertex_ai_sa_permissions" {
  for_each = toset([
    "roles/aiplatform.user",
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser",
    "roles/storage.objectAdmin",
    "roles/artifactregistry.reader"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
}

resource "google_service_account_iam_member" "vertex_ai_sa_token_creator" {
  service_account_id = google_service_account.vertex_ai_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
}