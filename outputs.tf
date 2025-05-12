output "vpn_server_public_ip" {
  description = "Public IP address of the VPN server"
  value       = hcloud_server.vpn_server.ipv4_address
}