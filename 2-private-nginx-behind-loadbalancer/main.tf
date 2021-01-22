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

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "secgroup_10"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_v2" "secgroup_20" {
  name        = "secgroup_20"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_201" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_20.id
}

// ---------------------------------------------------- Instances
resource "openstack_compute_keypair_v2" "keypair" {
  provider   = openstack.ovh
  name       = "keypair"
  public_key = file(var.ssh_key_location)
}

// ---------------------------------------------------- Load Balancer
resource "openstack_networking_port_v2" "port_loadbalancer" {
  provider       = openstack.ovh
  name           = "loadbalancer"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_1.id
    ip_address = "192.168.199.10"
  }
}

resource "openstack_compute_instance_v2" "loadbalancer" {
  provider        = openstack.ovh
  name            = "loadbalancer"
  image_name      = "Ubuntu 20.04"
  flavor_name     = "s1-2"
  key_pair        = openstack_compute_keypair_v2.keypair.name
  user_data       = templatefile("haproxy.sh", { ip_addrs = [openstack_compute_instance_v2.instance_1.access_ip_v4, openstack_compute_instance_v2.instance_2.access_ip_v4] })
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]

  network {
    name = "Ext-Net" # Nom de l'interface réseau publique
  }

  network {
    port = openstack_networking_port_v2.port_loadbalancer.id
  }
}

// ---------------------------------------------------- Instance 1
resource "openstack_networking_port_v2" "port_1" {
  provider       = openstack.ovh
  name           = "port_1"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_1.id
    ip_address = "192.168.199.11"
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  provider        = openstack.ovh
  name            = "instance_1"
  image_name      = "Ubuntu 20.04"
  flavor_name     = "s1-2"
  user_data       = templatefile("webserver.sh", { identifier = "instance_1" })
  security_groups = [openstack_networking_secgroup_v2.secgroup_20.name]

  network {
    port = openstack_networking_port_v2.port_1.id
  }
}

// ---------------------------------------------------- Instance 2
resource "openstack_networking_port_v2" "port_2" {
  provider       = openstack.ovh
  name           = "port_2"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_1.id
    ip_address = "192.168.199.12"
  }
}

resource "openstack_compute_instance_v2" "instance_2" {
  provider        = openstack.ovh
  name            = "instance_2"
  image_name      = "Ubuntu 20.04"
  flavor_name     = "s1-2"
  user_data       = templatefile("webserver.sh", { identifier = "instance_2" })
  security_groups = [openstack_networking_secgroup_v2.secgroup_20.name]

  network {
    port = openstack_networking_port_v2.port_2.id
  }
}
