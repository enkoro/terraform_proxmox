resource "mikrotik_dhcp_lease" "ct" {
  address    = var.network_ip
  macaddress = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
  comment    = var.hostname
  blocked    = "false"
}

resource "mikrotik_dns_record" "ct" {
  count   = var.create_local_dns_record ? 1 : 0
  name    = format("%s%s%s", var.hostname, ".", var.domain)
  address = var.network_ip
}

resource "proxmox_lxc" "pve" {
  description = var.ansible_hosts_file
  target_node = var.target_node
  hostname    = var.hostname
  cores       = var.cores
  memory      = var.memory
  password    = var.password
  start       = var.start
  hastate     = var.hastate
  network {
    name   = var.network_name
    bridge = var.network_bridge_type
    hwaddr = format("%s%s", var.network_mac_prefix, var.network_mac_postfix)
    ip     = "dhcp"
  }


  ssh_public_keys = var.ssh_key

  ostemplate = var.ostemplate
  rootfs {
    storage = var.rootfs_storage
    size    = var.rootfs_size
  }

  tags = join(";", sort(concat(var.tags, [var.network_ip])))

  provisioner "remote-exec" {
    inline = ["echo Hello from $(hostname -f)"]

    connection {
      host        = var.network_ip
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_file)
    }
  }

  # provisioner "local-exec" {
  #   command = <<EOT
  #     python3 ./external/ansible/tf_ansible_inventory.py ${self.description} add ${self.hostname} ${replace(self.tags, ";", " ")}
  #     ssh-keyscan -H ${var.network_ip} >> ${var.known_hosts_file}
  #     ssh-keyscan -H ${self.hostname} >> ${var.known_hosts_file}
  #     python3 ./external/ansible/tf_ansible_playbook.py ${self.hostname} ${join(" ", var.ansible_playbooks)}
  #   EOT
  # }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = <<EOT
  #     python3 ./external/ansible/tf_ansible_inventory.py ${self.description} rm ${self.hostname} ${split(";", self.tags)[0]}
  #     ssh-keygen -R ${split(";", self.tags)[0]}
  #     ssh-keygen -R ${self.hostname}
  #   EOT
  # }

}
