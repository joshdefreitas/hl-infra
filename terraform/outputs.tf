output "vm_ip" {
  value = var.vm_ip
  description = "The IP address of the created VM"
}

output "vm_id" {
  value = proxmox_vm_qemu.test_vm.id
  description = "The ID of the created VM in Proxmox"
}

output "vm_name" {
  value = proxmox_vm_qemu.test_vm.name
  description = "The name of the created VM"
}