variable "default_create_local_dns_record" {
  default = false
}

variable "default_ansible_playbook" {
  default = "/root/ansible/homelab/site.yml"
}

variable "default_target_node" {
  default = "lovejoy"
}
