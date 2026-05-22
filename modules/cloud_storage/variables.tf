variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, pp, prd)"
  type        = string
}

variable "location" {
  description = "Cloud Storage bucket location"
  type        = string
  default     = "US"
}