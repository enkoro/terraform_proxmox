variable "hostname" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "password" {
  type = string
}

variable "network_name" {
  type = string
}

variable "network_bridge_type" {
  type = string
}

variable "network_mac_prefix" {
  type = string
}

variable "network_mac_postfix" {
  type = string
}

variable "network_ip" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "ostemplate" {
  type = string
}

variable "rootfs_storage" {
  type = string
}

variable "rootfs_size" {
  type = string
}

variable "tags" {
  type = list(string)
}

variable "private_key_file" {
  type = string
}

variable "domain" {
  type = string
}

variable "create_local_dns_record" {
  type = bool
}
