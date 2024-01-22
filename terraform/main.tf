module "open_mds" {
  source = "./open_mds"

  # Required arguments
  lets_encrypt_email                       = var.lets_encrypt_email
  airflow_github_auth_app_client_id        = var.airflow_github_auth_app_client_id
  airflow_github_auth_app_client_secret    = var.airflow_github_auth_app_client_secret
  jupyterhub_github_auth_app_client_id     = var.jupyterhub_github_auth_app_client_id
  jupyterhub_github_auth_app_client_secret = var.jupyterhub_github_auth_app_client_secret
  superset_github_auth_app_client_id       = var.superset_github_auth_app_client_id
  superset_github_auth_app_client_secret   = var.superset_github_auth_app_client_secret
  host                                     = var.host
  clickhouse_username                      = var.clickhouse_username
  clickhouse_password                      = var.clickhouse_password
  superset_secret_key                      = var.superset_secret_key
  rbac                                     = var.rbac

  # Optional arguments
  kube_config_path         = var.kube_config_path
  kube_config_context      = var.kube_config_context
  ingress_namespace        = var.ingress_namespace
  lets_encrypt_environment = var.lets_encrypt_environment
  platform_namespace       = var.platform_namespace
}
