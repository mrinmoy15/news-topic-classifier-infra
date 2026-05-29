variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "cs-cdwp-data-pp2188"
}

variable "mlflow_image" {
  description = "Docker image URI for the MLflow tracking server (must include psycopg2)"
  type        = string
}