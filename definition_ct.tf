locals {
  cts = {
    "vault" = {
      cores       = 1
      memory      = 1024
      rootfs_size = "8G"
      template    = "local:vztmpl/ubuntu-22.10-standard_22.10-1_amd64.tar.zst"
      network_ip  = "192.168.1.15"
    }
  }


  default_ct_cores               = 2
  default_ct_memory              = 2048
  default_ct_network_name        = "eth0"
  default_ct_network_bridge_type = "vmbr0"
  default_ct_network_mac_prefix  = "B6:24:74:03:CC:"
  default_ct_rootfs_storage      = "data"
  default_ct_rootfs_size         = "8G"
  default_ct_tags                = ""
  default_ct_private_key_file    = "/root/.ssh/id_rsa"
}
