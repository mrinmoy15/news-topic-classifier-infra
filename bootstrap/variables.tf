variable "project_id" {
  description = "The GCP project ID to create bootstrap resources in"
  type        = string
  default     = "cs-cdwp-data-dev2188"
}

variable "github_org" {
  description = "Your GitHub username"
  type        = string
}

variable "github_repos" {
  description = "GitHub repo names allowed to authenticate via WIF"
  type        = list(string)
  default     = ["news-topic-classifier-infra", "news-topic-classifier"]
}

variable "dev_project_id" {
  description = "Dev project ID"
  type        = string
  default     = "cs-cdwp-data-dev2188"
}

variable "pp_project_id" {
  description = "Pre-prod project ID"
  type        = string
  default     = "cs-cdwp-data-pp2188"
}

variable "prd_project_id" {
  description = "Prod project ID"
  type        = string
  default     = "cs-cdwp-data-prd2188"
}