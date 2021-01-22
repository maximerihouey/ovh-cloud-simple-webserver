resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "secgroup"
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

resource "openstack_compute_keypair_v2" "keypair" {
  provider   = openstack.ovh
  name       = "key_pair"
  public_key = file(var.ssh_key_location)
}

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
