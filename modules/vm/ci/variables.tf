variable "hostname" {
  type = string
}

variable "template" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "rootfs_storage" {
  type = string
}

variable "rootfs_size" {
  type = string
}

variable "network_model" {
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

variable "tags" {
  type = list(string)
}

variable "private_key_file" {
  type = string
}

variable "user" {
  type = string
}

variable "password" {
  type = string
}

variable "domain" {
  type = string
}

variable "create_local_dns_record" {
  type = bool
}

variable "qemu_os" {
  type = string
}

variable "ansible_playbooks" {
  type = list(string)
}

variable "ansible_hosts_file" {
  type = string
}

variable "known_hosts_file" {
  type = string
}

variable "qemu_agent" {
  type = number
}

variable "hastate" {
  type = string
}

variable "vm_state" {
  type = string
}

variable "target_node" {
  type = string
}