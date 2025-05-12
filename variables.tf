variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of the SSH key pre-uploaded to Hetzner Cloud"
  type        = string
}

variable "location" {
  description = "Hetzner location for the server"
  type        = string
  default     = "hel1"
}

variable "server_type" {
  description = "Server type for the VPN"
  type        = string
  default     = "cpx11"
}

variable "hcloud_image" {
  description = "Hetzner image for the server"
  type = string
  default = "ubuntu-22.04" 
}

variable "cloudflare_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the DNS record"
  type        = string
}
variable "username" {
  description = "Username for SSH access"
  type        = string
  default     = "vpnuser"
}

variable "wireguard_port" {
  description = "Port for WireGuard"
  type        = number
  default     = 51820
}
variable "ansible_ssh_pubkey" {
  description = "Public key for Ansible user"
  type        = string
  sensitive   = true
}
