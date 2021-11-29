variable "project_root" {
  type    = string
}

variable "vm_name" {
  type    = string
  default = "outsystems-base-image"
}

variable "iso_checksum" {
  type = string
}

variable "iso_url" {
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

variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}
