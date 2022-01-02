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

# get remote state for networking info
data "terraform_remote_state" "network" {  
  backend = "local"
  config = {    
    path = "./network/terraform.tfstate"  
  }
}

# Create the jupyter server
resource "digitalocean_droplet" "jupyterhubdev" {
    image  = "ubuntu-20-04-x64"
    name   = "jupyterhub-01"
    region = "nyc3"
    size   = "s-2vcpu-4gb"
    ssh_keys = [32690924]
    vpc_uuid = data.terraform_remote_state.network.outputs.devvpc
}

# assign the floating IP
resource "digitalocean_floating_ip_assignment" "dev_ip_assignment" {
  ip_address = data.terraform_remote_state.network.outputs.devip
  droplet_id = digitalocean_droplet.jupyterhubdev.id
}

# output ipv4 address
output "dev_instance_ip_addr" {
  value = digitalocean_droplet.jupyterhubdev.ipv4_address
}
