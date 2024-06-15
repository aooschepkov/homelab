data "local_file" "ssh_public_key" {
  filename = var.ssh_pub_key
}

resource "proxmox_virtual_environment_download_file" "rocky_cloud_image" {
  content_type = "iso"
  datastore_id = "local-btrfs"
  node_name    = "proxmox"
  url          = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  file_name    = "rocky9.4.img"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = var.vm_count
  content_type = "snippets"
  datastore_id = "local-btrfs"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.vm_name}${count.index + 1}
    users:
      - default
      - name: ${var.vm_user}
        groups: sudo
        passwd: ${var.vm_pass}
        shell: /bin/bash
        ssh-authorized-keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    EOF

    file_name = "cloud-config-${var.vm_name}${count.index + 1}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count     = var.vm_count
  name      = "${var.vm_name}${count.index + 1}"
  node_name = "proxmox"

  cpu {
    type  = "x86-64-v2-AES"
    cores = var.vm_vcpus
  }

  memory {
    dedicated = var.vm_memory
  }

  initialization {
    datastore_id = "local-btrfs"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index].id
  }

  network_device {
    bridge = "vmbr0"
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 89
  }

  disk {
    datastore_id = "local-btrfs"
    file_id      = proxmox_virtual_environment_download_file.rocky_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.vm_disk_size
  }
}
