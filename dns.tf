resource "cloudflare_dns_record" "vpn_dns_record" {
  zone_id = var.cloudflare_zone_id
  comment = "VPN server DNS record"
  content = hcloud_server.vpn_server.ipv4_address
  name    = var.domain_name
  proxied = false
  ttl = 3600
  type = "A"
  depends_on = [ hcloud_server.vpn_server ]
}