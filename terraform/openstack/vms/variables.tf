variable "user_name" {
  type    = string
  default = "admin"
}

variable "tenant_name" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "password"
}

variable "auth_url" {
  type    = string
  default = "http://myauthurl:5000/v3"
}

variable "region" {
  type    = string
  default = "RegionOne"
}

variable "public_key" {
  type = string
}
