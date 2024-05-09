provider "proxmox" {
  endpoint = var.endpoint
  username = var.username
  password = var.password
  insecure = true
  tmp_dir  = "/var/tmp"
  ssh {
    username    = var.ssh_username
    agent       = true
    private_key = file(var.ssh_key)
  }
}
