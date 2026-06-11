variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, pp, prd)"
  type        = string
}

variable "region" {
  description = "Cloud Run service region"
  type        = string
  default     = "us-central1"
}

variable "mlflow_image" {
  description = "Docker image URI for the MLflow tracking server (must include psycopg2)"
  type        = string
}

variable "artifact_bucket" {
  description = "GCS bucket name used as MLflow artifact root"
  type        = string
}

variable "sql_instance_connection_name" {
  description = "Cloud SQL instance connection name (project:region:instance)"
  type        = string
}

variable "db_name" {
  description = "MLflow PostgreSQL database name"
  type        = string
}

variable "db_user" {
  description = "MLflow PostgreSQL user name"
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for the MLflow DB password"
  type        = string
}

variable "vertex_ai_sa_email" {
  description = "Vertex AI service account email granted run.invoker on the MLflow service"
  type        = string
}

variable "additional_invokers" {
  description = "Extra principals granted run.invoker (e.g. user:you@gmail.com for UI access)"
  type        = list(string)
  default     = []
}
