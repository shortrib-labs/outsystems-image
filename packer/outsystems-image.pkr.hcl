
variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "81920"
}

variable "iso_checksum" {
  type    = string
  default = "4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

variable "memsize" {
  type    = string
  default = "8192"
}

variable "numvcpus" {
  type    = string
  default = "4"
}

variable "vm_name" {
  type    = string
  default = "outsystems-base-image"
}

variable "vcenter_username" {
  type    = string
  default = "administrator@vsphere.local"
}

variable "vcenter_password" {
  type = string
}

variable "vcenter_server" {
  type = string
}

variable "vcenter_datacenter" {
  type = string
}

variable "vcenter_cluster" {
  type = string
}

variable "vcenter_datastore" {
  type = string
}

variable "vcenter_network" {
  type = string
}

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}

variable "output_directory" {
  type = string
}

variable "script_directory" {
  type = string
}

source "vsphere-iso" "outsystems-image" {
  vm_name    = var.vm_name
  vm_version = "19"

  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  CPUs                 = var.numvcpus
  RAM                  = var.memsize
  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }
  network_adapters {
    network      = var.vcenter_network
    network_card = "vmxnet3"
  }

  boot_wait        = var.boot_wait
  floppy_files     = ["${var.script_directory}/setup/autounattend.xml"]
  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "30m"

  communicator   = "winrm"
  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  winrm_timeout  = "4h"
  winrm_use_ssl  = true
  winrm_insecure = true

  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  datacenter          = var.vcenter_datacenter
  cluster             = var.vcenter_cluster
  datastore           = var.vcenter_datastore
  insecure_connection = true

  convert_to_template = true
  export {
    output_directory = var.output_directory
  }
}

build {
  sources = ["source.vsphere-iso.outsystems-image"]

  provisioner "powershell" {
    script = "${var.script_directory}/outsystems-test.ps1"
  }

  provisioner "powershell" {
    script = "${var.script_directory}/vmware-tools.ps1"
  }

  provisioner "powershell" {
    script = "${var.script_directory}/prepare-windows.ps1"
  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    script = "${var.script_directory}/install-windows-updates.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    script = "${var.script_directory}/install-outsystems-prereqs.ps1"
  }

  provisioner "powershell" {
    script = "${var.script_directory}/cleanup.ps1"
  }

  post-processor "shell-local" {
    inline = ["ovftool ${var.output_directory}/${var.vm_name}.vmx ${var.output_directory}/${var.vm_name}.ova"]
  }
}
