# https://github.com/kubernetes/ingress-nginx/tree/release-1.9/charts/ingress-nginx
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = "4.8.3"
  namespace        = var.ingress_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/ingress-nginx/values.yaml")}"
  ]
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/do-loadbalancer-hostname"
    value = "${var.ingress_namespace}.${var.host}"
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]
}

# https://github.com/cert-manager/cert-manager/tree/v1.13.3/deploy/charts/cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "1.13.3"
  namespace        = var.ingress_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/cert-manager/values.yaml")}"
  ]
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.ingress_nginx
  ]
}

# Find this chart in /charts/cert-issuer
resource "helm_release" "cert_issuer" {
  name             = "cert-issuer"
  chart            = "../charts/cert-issuer"
  namespace        = var.ingress_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/cert-issuer/values.yaml")}"
  ]
  set {
    name  = "letsencrypt_email"
    value = var.lets_encrypt_email
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.cert_manager,
    digitalocean_record.dns_record
  ]
}

# https://github.com/bitnami/charts/tree/5687b241a2daa04df4b38f8e4d7dd110c64f5c7c/bitnami/clickhouse
resource "helm_release" "clickhouse" {
  name             = "clickhouse"
  chart            = "oci://registry-1.docker.io/bitnamicharts/clickhouse"
  version          = "4.1.16"
  namespace        = var.platform_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/clickhouse/values.yaml")}"
  ]
  set {
    name  = "auth.username"
    value = var.clickhouse_username
  }
  set_sensitive {
    name  = "auth.password"
    value = var.clickhouse_password
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.cert_issuer
  ]
}

# https://github.com/apache/airflow/tree/helm-chart/1.11.0/chart
resource "helm_release" "airflow" {
  name             = "airflow"
  chart            = "airflow"
  repository       = "https://airflow.apache.org"
  version          = "1.11.0"
  namespace        = var.platform_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  wait             = false
  values           = [
    "${file("../charts/airflow/values.yaml")}"
  ]
  set {
    name  = "ingress.web.hosts[0].name"
    value = "${var.platform_namespace}.${var.host}"
  }
  set {
    name  = "config.webserver.base_url"
    value = "https://${var.platform_namespace}.${var.host}/airflow"
  }
  set {
    name  = "ingress.web.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  set {
    name  = "ingress.web.hosts[0].tls.secretName"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  set_sensitive {
    name  = "config.github_enterprise.client_id"
    value = var.github_oauth_client_id_airflow
  }
  set_sensitive {
    name  = "config.github_enterprise.client_secret"
    value = var.github_oauth_client_secret_airflow
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.cert_issuer
  ]
}

# https://github.com/pmint93/helm-charts/tree/metabase-2.10.4
resource "helm_release" "metabase" {
  name             = "metabase"
  chart            = "metabase"
  repository       = "https://pmint93.github.io/helm-charts"
  version          = "2.10.4"
  namespace        = var.platform_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/metabase/values.yaml")}"
  ]
  set {
    name  = "siteUrl"
    value = "https://${var.platform_namespace}.${var.host}"
  }
  set {
    name  = "ingress.hosts"
    value = "{${var.platform_namespace}.${var.host}}"
  }
  set {
    name  = "ingress.tls[0].hosts"
    value = "{${var.platform_namespace}.${var.host}}"
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.cert_issuer
  ]
}

# https://github.com/jupyterhub/zero-to-jupyterhub-k8s/tree/3.2.1/jupyterhub
resource "helm_release" "jupyterhub" {
  name             = "jupyterhub"
  chart            = "jupyterhub"
  repository       = "https://hub.jupyter.org/helm-chart/"
  version          = "3.2.1"
  namespace        = var.platform_namespace
  create_namespace = true
  lint             = true
  timeout          = 600
  values           = [
    "${file("../charts/jupyterhub/values.yaml")}"
  ]
  set {
    name  = "ingress.hosts"
    value = "{${var.platform_namespace}.${var.host}}"
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "letsencrypt-${var.lets_encrypt_environment}"
  }
  depends_on = [
    digitalocean_kubernetes_cluster.cluster,
    helm_release.cert_issuer
  ]
}
