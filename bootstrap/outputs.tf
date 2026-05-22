output "service_account_email" {
  description = "GitHub Actions service account email"
  value       = google_service_account.github_actions.email
}

output "workload_identity_provider" {
  description = "Workload Identity Provider - use this in GitHub Actions workflows"
  value       = google_iam_workload_identity_pool_provider.github.name
}