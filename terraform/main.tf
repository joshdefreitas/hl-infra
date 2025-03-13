terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "test_vm" {
  name = var.vm_name
  target_node = var.proxmox_node
  
  # Clone from template
  clone = var.template_name
  
  # VM settings
  cores = 2
  sockets = 1
  memory = 2048
  agent = 1
  
  # Disk configuration using newer disks block syntax
  disks {
    scsi {
      scsi0 {
        disk {
          size = 20
          storage = "local-lvm"  # Replace with your storage name
          iothread = true
          ssd = true
        }
      }
    }
  }
  
  # Boot configuration
  boot = "order=scsi0;net0"
  
  # Network
  network {
    id = 0
    bridge = "vmbr0"
    model = "virtio"
  }
  
  # Cloud-init settings
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  
  sshkeys = var.ssh_public_key
}