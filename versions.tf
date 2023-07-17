terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.14"
    }
    mikrotik = {
      source  = "ddelnano/mikrotik"
      version = "~> 0.10.0"
    }
  }
}
