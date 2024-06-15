locals {
  flavors = {
    "tiny-1-1024"   = { ram = 1024, vcpu = 1, disk = 0 },
    "tiny-1-2048"   = { ram = 2048, vcpu = 1, disk = 0 },
    "small-2-2048"  = { ram = 2048, vcpu = 2, disk = 0 },
    "small-2-4096"  = { ram = 4096, vcpu = 2, disk = 0 },
    "medium-4-4096" = { ram = 4096, vcpu = 4, disk = 0 },
    "medium-4-8192" = { ram = 8192, vcpu = 4, disk = 0 },
    "large-4-16384" = { ram = 16384, vcpu = 4, disk = 0 },
    "large-8-16384" = { ram = 16384, vcpu = 8, disk = 0 },
  }
}

resource "openstack_compute_flavor_v2" "flavor" {
  for_each = local.flavors

  name      = each.key
  ram       = each.value.ram
  vcpus     = each.value.vcpu
  disk      = each.value.disk
  is_public = true
}
