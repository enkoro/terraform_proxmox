module "pve_ct" {
  for_each                = local.cts
  hostname                = each.key
  ostemplate              = each.value.template
  network_ip              = each.value.network_ip
  cores                   = lookup(each.value, "cores", local.default_ct_cores)
  memory                  = lookup(each.value, "memory", local.default_ct_memory)
  network_name            = lookup(each.value, "network_name", local.default_ct_network_name)
  network_bridge_type     = lookup(each.value, "network_bridge_type", local.default_ct_network_bridge_type)
  network_mac_prefix      = local.default_ct_network_mac_prefix
  network_mac_postfix     = length(format("%X", split(".", each.value.network_ip)[3])) == 1 ? format("0%X", split(".", each.value.network_ip)[3]) : format("%X", split(".", each.value.network_ip)[3])
  rootfs_storage          = lookup(each.value, "rootfs_storage", local.default_ct_rootfs_storage)
  rootfs_size             = lookup(each.value, "rootfs_size", local.default_ct_rootfs_size)
  tags                    = concat(lookup(each.value, "tags", local.default_ct_tags), ["lxc"])
  private_key_file        = lookup(each.value, "private_key_file", local.default_ct_private_key_file)
  create_local_dns_record = lookup(each.value, "create_local_dns_record", var.default_create_local_dns_record)

  password = var.default_global_root_password
  ssh_key  = var.default_global_root_ssh_key
  domain   = var.default_global_domain

  source = "./modules/ct"
}

module "pve_vm_ci" {
  for_each                = local.civms
  hostname                = each.key
  template                = each.value.template
  cores                   = lookup(each.value, "cores", local.default_vm_cores)
  memory                  = lookup(each.value, "memory", local.default_vm_memory)
  rootfs_storage          = lookup(each.value, "rootfs_storage", local.default_vm_rootfs_storage)
  rootfs_size             = lookup(each.value, "rootfs_size", local.default_vm_rootfs_size)
  network_model           = lookup(each.value, "network_model", local.default_vm_network_model)
  network_bridge_type     = lookup(each.value, "network_bridge_type", local.default_vm_network_bridge_type)
  network_mac_prefix      = local.default_vm_network_mac_prefix
  network_mac_postfix     = length(format("%X", split(".", each.value.network_ip)[3])) == 1 ? format("0%X", split(".", each.value.network_ip)[3]) : format("%X", split(".", each.value.network_ip)[3])
  network_ip              = each.value.network_ip
  tags                    = concat(lookup(each.value, "tags", local.default_vm_tags), ["vm"])
  private_key_file        = lookup(each.value, "private_key_file", local.default_vm_private_key_file)
  create_local_dns_record = lookup(each.value, "create_local_dns_record", var.default_create_local_dns_record)
  qemu_os                 = lookup(each.value, "qemu_os", "other")

  user     = lookup(each.value, "user", local.default_vm_ci_user)
  password = var.default_global_root_password
  ssh_key  = var.default_global_root_ssh_key
  domain   = var.default_global_domain

  source = "./modules/vm/ci"
}
