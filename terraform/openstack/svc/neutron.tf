resource "openstack_networking_network_v2" "external_network" {
  external       = "true"
  name           = "external-net"
  admin_state_up = "true"
  segments {
    physical_network = "physnet1"
    network_type     = "vlan"
    segmentation_id  = 89
  }
}

resource "openstack_networking_subnet_v2" "external_network_subnet" {
  network_id = openstack_networking_network_v2.external_network.id
  name       = "ext_subnet1"
  cidr       = "192.168.89.0/24"
  gateway_ip = "192.168.89.1"
  allocation_pool {
    start = "192.168.89.10"
    end   = "192.168.89.100"
  }
}

resource "openstack_networking_network_v2" "internal_network" {
  name           = "internal-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "internal_network_subnet" {
  network_id  = openstack_networking_network_v2.internal_network.id
  name        = "int_subnet1"
  cidr        = "192.168.69.0/24"
  gateway_ip  = "192.168.69.1"
  enable_dhcp = true
  allocation_pool {
    start = "192.168.69.10"
    end   = "192.168.69.100"
  }
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router1"
  admin_state_up      = "true"
  external_network_id = openstack_networking_network_v2.external_network.id
  external_fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.external_network_subnet.id
    ip_address = "192.168.89.71"
  }
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.internal_network_subnet.id
}

resource "openstack_networking_secgroup_v2" "secgroup1" {
  name                 = "secgroup1"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  security_group_id = openstack_networking_secgroup_v2.secgroup1.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  security_group_id = openstack_networking_secgroup_v2.secgroup1.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_3" {
  security_group_id = openstack_networking_secgroup_v2.secgroup1.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_4" {
  security_group_id = openstack_networking_secgroup_v2.secgroup1.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
}
