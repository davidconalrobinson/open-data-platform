data "digitalocean_loadbalancer" "ingress_nginx_loadbalancer" {
  name = "ingress-nginx-load-balancer"
  depends_on = [
    helm_release.ingress_nginx
  ]
}
