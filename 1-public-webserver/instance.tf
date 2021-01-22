resource "openstack_networking_secgroup_v2" "secgroup" {
  name = "secgroup"
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
  name       = "keypair"
  public_key = file(var.ssh_key_location)
}

resource "openstack_compute_instance_v2" "instance" {
  name            = "instance"
  provider        = openstack.ovh
  image_name      = "Ubuntu 20.04"
  flavor_name     = "s1-2"
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]

  user_data = file("webserver.sh")
}
