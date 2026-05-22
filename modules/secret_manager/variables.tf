variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, pp, prd)"
  type        = string
}

variable "vertex_ai_sa_email" {
  description = "Vertex AI service account email that needs access to secrets"
  type        = string
}