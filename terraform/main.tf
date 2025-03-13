resource "proxmox_vm_qemu" "test_vm" {
  name = var.vm_name
  target_node = var.proxmox_node
  
  clone = var.template_name
  
  cores = 2
  sockets = 1
  memory = 2048
  
  agent = 1
  
  # Add disk configuration
  disk {
    type = "scsi"
    storage = "local-lvm"  # Replace with your actual storage pool name
    size = "20G"
    scsihw = "virtio-scsi-pci"
  }
  
  # Set boot order
  boot = "c"  # Boot from hard disk first
  
  # Network
  network {
    bridge = "vmbr0"
    model = "virtio"
    tag = -1
  }
  
  # Cloud-init settings
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  
  sshkeys = var.ssh_public_key
}