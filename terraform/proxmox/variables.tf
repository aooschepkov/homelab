variable "endpoint" {
  type    = string
  default = "https://proxmox:8006/"
}

variable "username" {
  type    = string
  default = "root@pam"
}

variable "password" {
  type    = string
  default = "pwd"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_key" {
  type    = string
  default = "/home/user/.ssh/id_rsa"
}

variable "ssh_pub_key" {
  type    = string
  default = "/home/user/.ssh/id_rsa.pub"
}

variable "vm_count" {
  type    = number
  default = 0
}

variable "vm_pass" {
  type = string
}

variable "vm_user" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_memory" {
  type = number
}

variable "vm_vcpus" {
  type = number
}

variable "vm_disk_size" {
  type = number
}
