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
  
  # Use the flat disk format instead of nested
  disk {
    type = "scsi"
    storage = "local-lvm"
    size = "20G"
    iothread = 1
    scsihw = "virtio-scsi-pci"
    # Note: no ssd parameter, use emulatessd instead if needed
    emulatessd = 1
  }
  
  # Boot configuration
  boot = "order=scsi0;net0"
  
  # Network without id parameter
  network {
    bridge = "vmbr0"
    model = "virtio"
  }
  
  # Cloud-init settings
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  
  sshkeys = var.ssh_public_key
}