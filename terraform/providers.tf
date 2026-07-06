# A `provider` block configures how Terraform talks to an API.
#
# For DigitalOcean we intentionally do not put the API token in tfvars.
# The provider will read it from the environment variable:
#
# PowerShell:
#   $env:DIGITALOCEAN_TOKEN = "dop_v1_..."
#
# Bash:
#   export DIGITALOCEAN_TOKEN="dop_v1_..."
provider "digitalocean" {}
