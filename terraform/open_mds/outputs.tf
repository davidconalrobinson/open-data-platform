output "ingress_nginx" {
  value = helm_release.ingress_nginx.metadata
}

output "cert_manager" {
  value = helm_release.cert_manager.metadata
}

output "cert_issuer" {
  value = helm_release.cert_issuer.metadata
}

output "clickhouse" {
  value = helm_release.clickhouse.metadata
}

output "airflow" {
  value = helm_release.airflow.metadata
}

output "superset" {
  value = helm_release.superset.metadata
}

output "jupyterhub" {
  value = helm_release.jupyterhub.metadata
}
