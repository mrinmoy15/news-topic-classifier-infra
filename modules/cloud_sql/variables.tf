variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, pp, prd)"
  type        = string
}

variable "region" {
  description = "Cloud SQL region"
  type        = string
  default     = "us-central1"
}

variable "database_tier" {
  description = "Cloud SQL machine type"
  type        = string
  default     = "db-f1-micro"
}

variable "deletion_protection" {
  description = "Enable deletion protection on the Cloud SQL instance"
  type        = bool
  default     = false
}
