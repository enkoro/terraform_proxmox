resource "mikrotik_dhcp_lease" "civm" {
  address    = var.network_ip
  macaddress = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
  comment    = var.hostname
  blocked    = "false"
}

resource "mikrotik_dns_record" "civm" {
  count   = var.create_local_dns_record ? 1 : 0
  name    = format("%s%s%s", var.hostname, ".", var.domain)
  address = var.network_ip
}

resource "proxmox_vm_qemu" "pve" {
  desc        = var.ansible_hosts_file
  target_node = var.target_node
  name        = var.hostname
  clone       = var.template
  cores       = var.cores
  memory      = var.memory
  onboot      = true
  ciuser      = var.user
  cipassword  = var.password
  os_type     = "cloud-init"
  qemu_os     = var.qemu_os
  agent       = var.qemu_agent
  hastate     = var.hastate
  vm_state    = var.vm_state

  disks {
    scsi{
      scsi0{
        disk{
          storage = var.rootfs_storage
          size    = var.rootfs_size
        }
      }
    }
  }
  scsihw = "virtio-scsi-pci"
  cloudinit_cdrom_storage = var.rootfs_storage

  network {
    model   = var.network_model
    macaddr = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
    bridge  = var.network_bridge_type
  }
  ipconfig0 = "ip=dhcp,ip6=dhcp"

  sshkeys = var.ssh_key
  tags    = join(";", sort(concat(var.tags, [var.network_ip])))

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
    quiet   = false
    command = "python3 ./external/ansible/provision.py -H ${trimspace(self.desc)} -N ${self.name} -T ${replace(self.tags, ";", " ")} -K ${var.known_hosts_file} -P ${join(" ", var.ansible_playbooks)}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "python3 ./external/ansible/destroy.py -H ${trimspace(self.desc)} -N ${self.name} -I ${split(";", self.tags)[0]}"
  }

}
