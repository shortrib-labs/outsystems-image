variable "project_root" {
  type    = string
}

variable "vm_name" {
  type    = string
  default = "outsystems-base-image"
}

variable "default_password" {
  type    = string
}

variable "image_url" {
  type = string
}

variable "image_checksum" {
  type = string
}

variable "memsize" {
  type = string
}

variable "numvcpus" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "vsphere_username" {
  type    = string
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_content_library" {
  type = string
}

variable "vsphere_network" {
  type = string
}

variable "boot_wait" {
  type    = string
  default = "2s"

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}
