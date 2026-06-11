# ── Enable Required APIs on all projects ──────────────
locals {
  projects = [
    var.dev_project_id,
    var.pp_project_id,
    var.prd_project_id
  ]

  apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "run.googleapis.com",
    "cloudscheduler.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com"
  ]

  project_api_pairs = {
    for pair in setproduct(local.projects, local.apis) :
    "${pair[0]}/${pair[1]}" => {
      project = pair[0]
      api     = pair[1]
    }
  }
}

resource "google_project_service" "apis" {
  for_each = local.project_api_pairs

  project            = each.value.project
  service            = each.value.api
  disable_on_destroy = false
}

# ── Service Account for GitHub Actions ────────────────
resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
  description  = "Used by GitHub Actions to run Terraform"
}

# ── Workload Identity Pool ─────────────────────────────
resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
}

# ── Workload Identity Provider ─────────────────────────
resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository in ['${join("', '", [for r in var.github_repos : "${var.github_org}/${r}"])}']"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# ── Allow GitHub Actions to impersonate Service Account
resource "google_service_account_iam_member" "github_wif" {
  for_each = toset(var.github_repos)

  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_org}/${each.value}"
}

# ── Grant Service Account permissions on all projects ─
resource "google_project_iam_member" "github_actions_permissions" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_iam_admin" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# ── Terraform State Buckets ───────────────────────────
resource "google_storage_bucket" "terraform_state" {
  for_each = toset(local.projects)

  project       = each.value
  name          = "${each.value}-terraform-state"
  location      = "US"
  force_destroy = false

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  labels = {
    purpose    = "terraform-state"
    managed_by = "terraform"
  }
}

# ── Grant GitHub Actions SA access to state buckets ───
resource "google_storage_bucket_iam_member" "terraform_state_access" {
  for_each = toset(local.projects)

  bucket = google_storage_bucket.terraform_state[each.value].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_secret_admin" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_ar_writer" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_aiplatform_user" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "ml_repo_ar_writer" {
  for_each = toset(local.projects)

  project = each.value
  role    = "roles/artifactregistry.writer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_org}/news-topic-classifier"
}