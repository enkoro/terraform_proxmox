resource "mikrotik_dhcp_lease" "civm" {
  address    = var.network_ip
  macaddress = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
  comment    = var.hostname
  blocked    = "false"
}

resource "mikrotik_dns_record" "civm" {
  name    = format("%s%s%s", var.hostname, ".", var.domain)
  address = var.network_ip
}

resource "proxmox_vm_qemu" "pve" {
  target_node = "pve"
  name        = var.hostname
  clone       = var.template
  cores       = var.cores
  memory      = var.memory
  onboot      = true
  cipassword  = var.password
  os_type     = "cloud-init"

  disk {
    type    = "scsi"
    storage = var.rootfs_storage
    size    = var.rootfs_size
  }
  scsihw = "virtio-scsi-pci"

  network {
    model   = var.network_model
    macaddr = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
    bridge  = var.network_bridge_type
  }
  ipconfig0 = "ip=dhcp,ip6=dhcp"

  sshkeys = var.ssh_key
  tags    = format("%s %s %s", var.network_ip, "vm", var.tags)

  provisioner "remote-exec" {
    inline = ["echo Hello from $(hostname -f)"]

    connection {
      host        = var.network_ip
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_file)
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      python3 ./external/ansible/tf_ansible_inventory.py add ${self.name} ${replace(self.tags, ";", " ")}
      ssh-keyscan -H ${var.network_ip} >> /root/.ssh/known_hosts
      ssh-keyscan -H ${self.name} >> /root/.ssh/known_hosts
      python3 ./external/ansible/tf_ansible_playbook.py ${self.name} vm ${replace(var.tags, ";", " ")}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      python3 ./external/ansible/tf_ansible_inventory.py rm ${self.name} ${split(" ", self.tags)[0]}
      ssh-keygen -R ${split(";", self.tags)[0]}
      ssh-keygen -R ${self.name}
    EOT
  }

}
