locals {
  directories = {
    "scripts"  = "${var.project_root}/src/powershell"
    "setup"  = "${var.project_root}/src/xml"
  }
}
  
source "vsphere-iso" "outsystems-template" {
  vm_name       = var.vm_name
  guest_os_type = "windows2019srv_64Guest"
  firmware      = "efi-secure"

  iso_url      = var.image_url
  iso_checksum = var.image_checksum

  CPUs                 = var.numvcpus
  RAM                  = var.memsize
  disk_controller_type = ["lsilogic-sas"]
  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.vsphere_network
    network_card = "vmxnet3"
  }

  boot_order       = "disk,cdrom"
  boot_command     = [ "<spacebar>" ] 
  boot_wait        = var.boot_wait
  floppy_content   = {
    "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
      default_password       = var.default_password
    })
    "install-vmware-tools.ps1" = file("${local.directories.scripts}/windows-vmtools.ps1")
    "enable-remote-access.ps1" = file("${local.directories.scripts}/enable-remote-access.ps1")
  }
  iso_paths = [ 
    "[] /vmimages/tools-isoimages/windows.iso"
  ]

  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "30m"

  communicator   = "winrm"
  winrm_insecure = true
  winrm_timeout  = "4h"
  winrm_use_ssl  = true
  winrm_username = var.winrm_username
  winrm_password = var.default_password

  vcenter_server      = var.vsphere_server
  username            = var.vsphere_username
  password            = var.vsphere_password
  datacenter          = var.vsphere_datacenter
  cluster             = var.vsphere_cluster
  datastore           = var.vsphere_datastore

  export {
    name  = var.vm_name
    images = false
    force = true

    output_directory = var.output_directory
  }
}

build {
  sources = ["source.vsphere-iso.outsystems-template"]

  provisioner "powershell" {
    script = "${local.directories.scripts}/outsystems-test.ps1"
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
    script = "${local.directories.scripts}/cleanup.ps1"
  }

  post-processor "shell-local" {
    inline = ["govc vm.destroy ${var.vm_name}"]
  }
}
