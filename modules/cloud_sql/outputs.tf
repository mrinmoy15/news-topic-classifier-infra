output "instance_connection_name" {
  description = "Cloud SQL instance connection name (project:region:instance)"
  value       = google_sql_database_instance.mlflow.connection_name
}

output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.mlflow.name
}

output "database_name" {
  description = "MLflow PostgreSQL database name"
  value       = google_sql_database.mlflow.name
}

output "user_name" {
  description = "MLflow PostgreSQL user name"
  value       = google_sql_user.mlflow.name
}

output "password_secret_id" {
  description = "Secret Manager secret ID for the MLflow DB password"
  value       = google_secret_manager_secret.mlflow_db_password.secret_id
}

output "password_secret_name" {
  description = "Secret Manager full resource name for the MLflow DB password"
  value       = google_secret_manager_secret.mlflow_db_password.name
}
