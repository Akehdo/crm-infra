# `variable` declares an input value. Values can come from terraform.tfvars,
# `-var`, `-var-file`, or environment variables named `TF_VAR_<name>`.
variable "project_name" {
  description = "Project name"

  # `type` tells Terraform what kind of value is valid.
  type = string

  # `default` makes the variable optional.
  default = "cargo_crm"
}

# Environment label. It becomes part of resource names and tags.
variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# DigitalOcean region slug. Examples: fra1, ams3, nyc3.
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"
}

# Droplet size slug. 1 GB is okay for practice; 2 GB is calmer for app+db+redis.
variable "droplet_size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

# Local path to your public SSH key. Terraform uploads this key to DigitalOcean.
variable "ssh_public_key_path" {
  description = "Path to local public SSH key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

# CIDR blocks allowed to connect over SSH.
# For production prefer your own IP, for example: ["46.34.195.229/32"].
variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
