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

locals {
  rules = {
    "allow_ssh_in"       = { direction = "ingress", port_range_min = 22, port_range_max = 22, protocol = "tcp" },
    "allow_icmp_in"      = { direction = "ingress", protocol = "icmp" },
    "allow_icmp_out"     = { direction = "egress", protocol = "icmp" },
    "allow_https_out"    = { direction = "egress", port_range_min = 443, port_range_max = 443, protocol = "tcp" },
    "allow_nodeport_in"  = { direction = "ingress", port_range_min = 30000, port_range_max = 32767, protocol = "tcp" } # udp - ?
    "allow_apiserver_in" = { direction = "ingress", port_range_min = 6443, port_range_max = 6443, protocol = "tcp" }
  }
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rules" {
  for_each = local.rules

  security_group_id = openstack_networking_secgroup_v2.secgroup1.id
  description       = each.key
  direction         = each.value.direction
  protocol          = each.value.protocol
  port_range_min    = try(each.value.port_range_min, null)
  port_range_max    = try(each.value.port_range_max, null)
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}
