# `locals` declares calculated values that are reused in this module.
locals {
  # Interpolation syntax `${...}` inserts variable/resource values into strings.
  name = "${var.project_name}-${var.env}"

  # Tags help group and filter DigitalOcean resources.
  tags = [
    digitalocean_tag.project.name,
    digitalocean_tag.env.name,
    digitalocean_tag.managed_by_terraform.name
  ]
}

# `resource` tells Terraform to create/manage an object in a provider.
# Format: resource "<TYPE>" "<LOCAL_NAME>" { ... }
resource "digitalocean_tag" "project" {
  # `var.project_name` reads the input variable declared in variables.tf.
  name = var.project_name
}

resource "digitalocean_tag" "env" {
  name = var.env
}

resource "digitalocean_tag" "managed_by_terraform" {
  name = "managed-by-terraform"
}

# Uploads your public SSH key to DigitalOcean.
resource "digitalocean_ssh_key" "main" {
  name = "${local.name}-ssh-key"

  # `file(...)` reads a local file. Here it reads ~/.ssh/id_ed25519.pub.
  public_key = file(var.ssh_public_key_path)
}

# Creates the Ubuntu server.
resource "digitalocean_droplet" "app" {
  name = "${local.name}-app-01"

  # DigitalOcean image slug.
  image = "ubuntu-24-04-x64"

  # Region and size come from variables so they are easy to change.
  region = var.region
  size   = var.droplet_size

  # Enables IPv6 on the droplet.
  ipv6 = true

  # Disabled for learning/cost control. For production, consider true.
  backups = false

  # Attaches the uploaded SSH key to the droplet.
  ssh_keys = [
    digitalocean_ssh_key.main.fingerprint
  ]

  tags = local.tags
}

# Firewall attached to the app droplet.
resource "digitalocean_firewall" "app" {
  name = "${local.name}-firewall"

  # Attach this firewall to the droplet above.
  droplet_ids = [
    digitalocean_droplet.app.id
  ]

  # Inbound SSH. Keep this restricted to your IP when possible.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.allowed_ssh_cidrs
  }

  # Inbound HTTP. Needed for Caddy/nginx and Let's Encrypt HTTP challenge.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Inbound HTTPS. This is the main public entrypoint for the CRM.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound TCP. Needed for apt, Docker pulls, HTTPS APIs, etc.
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound UDP. Needed for DNS and other basic networking.
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound ICMP. Useful for ping/troubleshooting.
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
