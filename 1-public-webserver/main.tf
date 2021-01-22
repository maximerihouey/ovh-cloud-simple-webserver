terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3.0/"
  domain_name = "default" # keep "default" for OVH
  alias       = "ovh"

  # OpenStack credentials
  user_name = var.open_stack_user_name
  password  = var.open_stack_password
}
