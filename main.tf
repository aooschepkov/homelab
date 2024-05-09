data "local_file" "ssh_public_key" {
  filename = var.ssh_pub_key
}

resource "proxmox_virtual_environment_vm" "alma_vm" {
  count     = var.vm_count
  name      = "alma-${count.index}"
  node_name = "proxmox"

  cpu {
    type  = "x86-64-v2-AES"
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  initialization {
    datastore_id = "local-btrfs"
    user_account {
      username = "andrew"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 89
  }

  disk {
    datastore_id = "local-btrfs"
    file_id      = proxmox_virtual_environment_download_file.alma_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 25
    ssd          = true
  }
}

resource "proxmox_virtual_environment_download_file" "alma_cloud_image" {
  content_type = "iso"
  datastore_id = "local-btrfs"
  node_name    = "proxmox"
  url          = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.4-20240507.x86_64.qcow2"
  file_name    = "almalinux9.img"
}
