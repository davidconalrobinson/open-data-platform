resource "digitalocean_record" "dns_record" {
  for_each = toset(concat([var.ingress_namespace], [var.platform_namespace]))
  domain   = digitalocean_domain.domain.id
  type     = "A"
  name     = each.value
  value    = data.digitalocean_loadbalancer.ingress_nginx_loadbalancer.ip
  ttl      = 30
}
