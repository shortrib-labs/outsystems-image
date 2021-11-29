locals {
  directories = {
    "scripts"  = "${var.project_root}/src/powershell"
    "setup"  = "${var.project_root}/src/xml"
    "output"   = "${var.project_root}/work/${var.vm_name}"
  }
}
  
source "vmware-iso" "outsystems-image" {
  vm_name       = var.vm_name
  guest_os_type = "windows2019srv-64"

  iso_checksum = var.iso_checksum
  iso_url      = var.iso_url

  cpus              = var.numvcpus
  memory            = var.memsize
  disk_size         = var.disk_size
  disk_type_id      = "0"
  disk_adapter_type = "lsisas1068"

  boot_wait        = var.boot_wait
  floppy_files     = ["${local.directories.setup}/autounattend.xml"]
  headless         = false
  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "30m"

  communicator   = "winrm"
  winrm_insecure = true
  winrm_password = var.winrm_password
  winrm_timeout  = "4h"
  winrm_use_ssl  = true
  winrm_username = var.winrm_username

  output_directory = local.directories.output
  format           = "ova"
  ovftool_options  = [ "--noImageFiles" ]
  skip_compaction  = false
}

build {
  sources = ["source.vmware-iso.outsystems-image"]

  provisioner "powershell" {
    script = "${local.directories.scripts}/outsystems-test.ps1"
  }

  provisioner "powershell" {
    script = "${local.directories.scripts}/vmware-tools.ps1"
  }

  provisioner "powershell" {
    script = "${local.directories.scripts}/prepare-windows.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    script = "${local.directories.scripts}/install-windows-updates.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
   script = "${local.directories.scripts}/install-outsystems-prereqs.ps1"
  }

  provisioner "powershell" {
   script = "${local.directories.scripts}/install-outsystems-server.ps1"
  }

  provisioner "powershell" {
    script = "${local.directories.scripts}/enable-remote-access.ps1"
  }

  provisioner "powershell" {
    script = "${local.directories.scripts}/cleanup.ps1"
  }

}
