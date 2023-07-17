provider "proxmox" {
  pm_api_url = "https://192.168.1.10:8006/api2/json"
}

provider "mikrotik" {
  host     = "192.168.1.1:8728"
  tls      = false
  insecure = true
}
