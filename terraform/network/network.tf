terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
  type = string
  description = "api token for digital ocean"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# create floating ip for the dev env
resource "digitalocean_floating_ip" "devip" {
  region     = "nyc3"
}

# create vpc for the jupyterhub dev env
resource "digitalocean_vpc" "devvpc" {
  name     = "jupyterhub-dev-network"
  region   = "nyc3"
  ip_range = "10.10.10.0/24"
}

output "devip" {
  value = digitalocean_floating_ip.devip.ip_address
}

output "devvpc" {
    value = digitalocean_vpc.devvpc.id
}