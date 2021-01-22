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

  network {
    port = openstack_networking_port_v2.port_2.id
  }
}
