terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "openstack" {
  auth_url = "https://auth.cloud.ovh.net/v3.0/"
  domain_name = "default" # keep "default" for OVH
  alias = "ovh"

  # OpenStack credentials
  user_name   = var.open_stack_user_name
  password    = var.open_stack_password
}

resource "openstack_compute_keypair_v2" "keypair" {
  provider   = openstack.ovh
  name       = "keypair"
  public_key = file("~/.ssh/id_rsa_ovh.pub")
}

resource "openstack_compute_instance_v2" "instance" {
   name = "instance"
   provider = openstack.ovh
   image_name = "Ubuntu 20.04"
   flavor_name = "s1-2"
   key_pair    = openstack_compute_keypair_v2.keypair.name

  user_data = file("user-data.sh")
}
