data "hcloud_ssh_key" "default" {
  name = var.ssh_key_name
}

resource "hcloud_server" "vpn_server" {
  name        = var.vpn_server_name
  server_type = var.server_type
  image       = var.hcloud_image
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.default.name]
  firewall_ids = [hcloud_firewall.vpn_firewall.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - wireguard
      - qrencode
      - python3
    users:
      - name: ${var.username}
        groups: users, admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${data.hcloud_ssh_key.default.public_key}
      - name: ansible
        groups: users, admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${var.ansible_ssh_pubkey}
    runcmd:
        - sed -i -e '/^\(#\|\)PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
        - sed -i -e '/^\(#\|\)PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
        - reboot
  EOF

    lifecycle {
      ignore_changes = [user_data]
    }
}