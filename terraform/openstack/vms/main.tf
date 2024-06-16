resource "openstack_blockstorage_volume_v3" "myvol" {
  name = "myvol"
  size = 10
}

data "openstack_compute_flavor_v2" "flavor" {
  vcpus = 2
  ram   = 2048
}

data "openstack_images_image_v2" "image" {
  name_regex = "rocky.*"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "keypair"
  public_key = var.public_key
}

resource "openstack_compute_instance_v2" "myinstance" {
  # depends_on = [openstack_images_image_v2.image, openstack_networking_subnet_v2.internal_network_subnet]

  name            = "myinstance"
  image_name      = data.openstack_images_image_v2.image.name
  flavor_name     = data.openstack_compute_flavor_v2.flavor.name
  key_pair        = openstack_compute_keypair_v2.keypair.id
  security_groups = ["secgroup1"]
  admin_pass      = "Passw0rd"

  network {
    name = "internal-net"
  }
}

resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = openstack_compute_instance_v2.myinstance.id
  volume_id   = openstack_blockstorage_volume_v3.myvol.id
}
