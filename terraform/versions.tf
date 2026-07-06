# The top-level `terraform` block configures Terraform itself, not cloud resources.
terraform {
  # `required_version` protects the project from running on very old Terraform versions.
  required_version = ">= 1.6.0"

  # `required_providers` declares external plugins Terraform must download.
  required_providers {
    # `digitalocean` is the local provider name used by resources like
    # `digitalocean_droplet`.
    digitalocean = {
      # `source` is the provider address in the Terraform Registry.
      source = "digitalocean/digitalocean"

      # `version` pins compatible provider versions.
      # `~> 2.93` means: allow 2.x updates from 2.93 upward, but not 3.x.
      version = "~> 2.93"
    }
  }
}
