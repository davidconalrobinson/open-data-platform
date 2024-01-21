variable digital_ocean_token {
  description = "DigitalOcean token"
  type        = string
  sensitive   = true
}

variable cluster_name {
  description = "Name of kubernetes cluster"
  type        = string
  default     = "data-platform"
}

variable cluster_region {
  description = "Kubernetes cluster regions"
  type        = string
  default     = "ams3"
}

variable cluster_version {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.28.2-do.0"
}

variable node_size {
  description = "Kubernetes default node size"
  type        = string
  default     = "s-4vcpu-8gb"
}

variable min_nodes {
  description = "Minimum number of kubernetes cluster nodes"
  type        = number
  default     = 1
}

variable max_nodes {
  description = "Maximum number of kubernetes cluster nodes"
  type        = number
  default     = 3
}

variable ingress_namespace {
  description = "Namespace used for deploying ingress resources"
  type        = string
  default     = "ingress"
}

variable lets_encrypt_environment {
  description = "Prod or staging - not that the prod environment has very strict API rate limits, so you should use staging for testing/development"
  type        = string
}

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

variable platform_namespace {
  description = "Namespace used for deploying data platform resources"
  type        = string
  default     = "default"
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
