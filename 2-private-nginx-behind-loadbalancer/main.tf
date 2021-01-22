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

resource "openstack_networking_network_v2" "network_1" {
  provider       = openstack.ovh
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  provider   = openstack.ovh
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
  ip_version = 4
}
