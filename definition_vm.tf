locals {
  civms = {
    "testvm" = {
      cores       = 1
      memory      = 1024
      rootfs_size = "8G"
      template    = "ci-ubuntu-template"
      network_ip  = "192.168.1.15"
    }
  }

  default_vm_cores               = 2
  default_vm_memory              = 2048
  default_vm_network_mac_prefix  = "B6:24:74:03:FF:"
  default_vm_rootfs_storage      = "data"
  default_vm_rootfs_size         = "32G"
  default_vm_network_model       = "virtio"
  default_vm_network_bridge_type = "vmbr0"
  default_vm_tags                = ""
  default_vm_private_key_file    = "/root/.ssh/id_rsa"
}
