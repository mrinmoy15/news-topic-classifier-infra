resource "random_password" "mlflow_db" {
  length  = 20
  special = false
}

resource "google_sql_database_instance" "mlflow" {
  project          = var.project_id
  name             = "${var.project_id}-mlflow"
  database_version = "POSTGRES_15"
  region           = var.region

  deletion_protection = var.deletion_protection

  settings {
    tier = var.database_tier

    backup_configuration {
      enabled = var.deletion_protection
    }

    ip_configuration {
      ipv4_enabled = true
    }

    user_labels = {
      environment = var.environment
      managed_by  = "terraform"
      purpose     = "mlflow-backend"
    }
  }
}

resource "google_sql_database" "mlflow" {
  project  = var.project_id
  name     = "mlflow"
  instance = google_sql_database_instance.mlflow.name
}

resource "google_sql_user" "mlflow" {
  project  = var.project_id
  name     = "mlflow"
  instance = google_sql_database_instance.mlflow.name
  password = random_password.mlflow_db.result
}

resource "google_secret_manager_secret" "mlflow_db_password" {
  project   = var.project_id
  secret_id = "mlflow-db-password"

  replication {
    auto {}
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "mlflow-db-password"
  }
}

resource "google_secret_manager_secret_version" "mlflow_db_password" {
  secret      = google_secret_manager_secret.mlflow_db_password.id
  secret_data = random_password.mlflow_db.result
}
