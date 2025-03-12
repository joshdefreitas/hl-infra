variable "proxmox_api_url" {
  type = string
  description = "The URL of the Proxmox API"
}

variable "proxmox_api_token_id" {
  type = string
  description = "Proxmox API token ID"
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  description = "Proxmox API token secret"
  sensitive = true
}

variable "proxmox_node" {
  type = string
  description = "Proxmox node name"
  default = "pve-01"
}

variable "template_name" {
  type = string
  description = "Name of the VM template to clone"
  default = "ubuntu-server-template"
}

variable "vm_name" {
  type = string
  description = "Name of the VM to create"
}

variable "vm_ip" {
  type = string
  description = "IP address for the VM"
}

variable "gateway" {
  type = string
  description = "Network gateway"
  default = "192.168.1.1"
}

variable "ssh_public_key" {
  type = string
  description = "SSH public key for VM access"
}