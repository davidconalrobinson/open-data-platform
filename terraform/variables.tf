variable lets_encrypt_email {
  description = "Email address to be associated with the ACME account (make sure it's a valid one)"
  type        = string
}

variable airflow_github_auth_app_client_id {
  description = "Client ID for github app used for airflow oauth"
  type        = string
}

variable airflow_github_auth_app_client_secret {
  description = "Client secret for github app used for airflow oauth"
  type        = string
  sensitive   = true
}

variable jupyterhub_github_auth_app_client_id {
  description = "Client ID for github app used for jupyterhub oauth"
  type        = string
}

variable jupyterhub_github_auth_app_client_secret {
  description = "Client secret for github app used for jupyterhub oauth"
  type        = string
  sensitive   = true
}

variable superset_github_auth_app_client_id {
  description = "Client ID for github app used for superset oauth"
  type        = string
}

variable superset_github_auth_app_client_secret {
  description = "Client secret for github app used for superset oauth"
  type        = string
  sensitive   = true
}

variable host {
  description = "Domain used for hosting data platform (e.g: my.domain.com)"
  type        = string
}

variable clickhouse_username {
  description = "Clickhouse username"
  type        = string
}

variable clickhouse_password {
  description = "Clickhouse password"
  type        = string
  sensitive   = true
}

variable superset_secret_key {
  description = "Superset secret key"
  type        = string
  sensitive   = true
}
variable rbac {
  description = "Map of users and their corresponding rbac role"
  type        = map(
    object(
      {
        platform_role = string
      }
    )
  )
}

variable kube_config_path {
  description = "Path to kube config"
  type        = string
  default     = "~/.kube/config"
}

variable kube_config_context {
  description = "Context to use from kube config"
  type        = string
  default     = "default"
}

variable ingress_namespace {
  description = "Namespace used for deploying ingress resources"
  type        = string
  default     = "ingress"
}

variable lets_encrypt_environment {
  description = "Prod or staging - note that the prod environment has very strict API rate limits, so you should use staging for testing/development"
  type        = string
  default     = "staging"
}

variable platform_namespace {
  description = "Namespace used for deploying data platform resources"
  type        = string
  default     = "default"
}

variable airflow_dag_sync_repo {
  description = "Airflow DAG git sync repo"
  type        = string
  default     = "https://github.com/davidconalrobinson/open-mds.git"
}

variable airflow_dag_sync_branch {
  description = "Airflow DAG git sync branch"
  type        = string
  default     = "master"
}

variable airflow_dag_sync_subpath {
  description = "Airflow DAG git sync subpath"
  type        = string
  default     = "examples/quick_start/dags"
}
