resource "google_service_account" "mlflow_sa" {
  project      = var.project_id
  account_id   = "mlflow-sa"
  display_name = "MLflow Tracking Server Service Account"
  description  = "Service account for the MLflow Cloud Run service"
}

resource "google_project_iam_member" "mlflow_sa_cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.mlflow_sa.email}"
}

resource "google_project_iam_member" "mlflow_sa_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mlflow_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "mlflow_sa_db_secret" {
  project   = var.project_id
  secret_id = var.db_password_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.mlflow_sa.email}"
}

resource "google_cloud_run_v2_service" "mlflow" {
  project  = var.project_id
  name     = "mlflow-tracking-server"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.mlflow_sa.email

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.sql_instance_connection_name]
      }
    }

    containers {
      image   = var.mlflow_image
      command = ["/bin/sh"]
      args = [
        "-c",
        "mlflow server --backend-store-uri postgresql+psycopg2://${var.db_user}:$${DB_PASSWORD}@/${var.db_name}?host=/cloudsql/${var.sql_instance_connection_name} --default-artifact-root gs://${var.artifact_bucket}/mlflow-artifacts --host 0.0.0.0 --port 8080"
      ]

      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "latest"
          }
        }
      }

      ports {
        container_port = 8080
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }

    labels = {
      environment = var.environment
      managed_by  = "terraform"
      purpose     = "mlflow-tracking"
    }
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "mlflow-tracking"
  }
}

resource "google_cloud_run_v2_service_iam_member" "vertex_ai_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.mlflow.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.vertex_ai_sa_email}"
}
