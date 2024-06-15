resource "openstack_images_image_v2" "image" {
  name             = "rocky-9"
  container_format = "bare"
  disk_format      = "qcow2"
  min_disk_gb      = 10
  visibility       = "public"
  image_source_url = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  properties = {
    "os_admin_user" = "rocky"
  }
}
