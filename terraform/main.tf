terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
}

resource "proxmox_vm_qemu" "test_vm" {
  name        = var.vm_name
  desc        = "VM created via Terraform"
  target_node = var.proxmox_node
  
  # Clone from template
  clone       = var.template_name
  
  # VM settings
  agent                  = 1
  automatic_reboot       = true
  balloon                = 0
  bios                   = "seabios"
  boot                   = "order=scsi0;net0"
  cores                  = 2
  define_connection_info = true
  force_create           = false
  hotplug                = "network,disk,usb"
  memory                 = 2048
  numa                   = false
  onboot                 = false
  scsihw                 = "virtio-scsi-pci"
  sockets                = 1
  
  # Disk configuration - using disks block instead of disk
  disks {
    scsi {
      scsi0 {
        disk {
          backup   = true
          cache    = "none"
          discard  = true
          iothread = true
          size     = "20G"
          storage  = "local-lvm"
        }
      }
    }
  }
  
  # Network configuration
  network {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }
  
  # Cloud-init settings
  os_type    = "cloud-init"
  ipconfig0  = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  sshkeys    = var.ssh_public_key
}