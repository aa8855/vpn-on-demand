resource "hcloud_firewall" "vpn_firewall" {
  name = "vpn-firewall-on-demand"
  rule {
    direction = "in"
    protocol  = "udp"
    port      = var.wireguard_port
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
     source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}