terraform {
  required_providers {
    proxmox = {
      source  = "local/telmate/proxmox"
      version = ">= 3.0.0"
    }
    mikrotik = {
      source  = "ddelnano/mikrotik"
      version = ">= 0.15.0"
    }
  }
}
