terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
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
  
  # If template_name is a name (string), this is fine
  # If it's a numeric ID, make sure var.template_name is defined as a number
  clone = var.template_name
  
  # VM settings - these look good as numbers
  cores = 2
  sockets = 1
  memory = 2048
  
  # Add agent parameter explicitly as a number
  agent = 1
  
  # Network
  network {
    bridge = "vmbr0"
    model = "virtio"
    # Explicitly set any numeric parameters
    tag = -1  # If not using VLAN tagging
  }
  
  # Cloud-init settings
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  
  sshkeys = var.ssh_public_key
}