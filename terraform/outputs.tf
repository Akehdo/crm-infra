# `output` prints a useful value after `terraform apply`.
output "app_public_ip" {
  description = "Public IPv4 address of the app server"

  # Resource references use: <resource_type>.<local_name>.<attribute>
  value = digitalocean_droplet.app.ipv4_address
}

output "app_ipv6" {
  description = "Public IPv6 address of the app server"
  value       = digitalocean_droplet.app.ipv6_address
}

output "ssh_command" {
  description = "SSH command"

  # Handy copy-paste command for connecting to the droplet.
  value = "ssh root@${digitalocean_droplet.app.ipv4_address}"
}

output "ansible_inventory" {
  description = "Ansible inventory line"

  # This line can later go into ansible/inventories/production.ini.
  value = "${digitalocean_droplet.app.ipv4_address} ansible_user=root"
}
