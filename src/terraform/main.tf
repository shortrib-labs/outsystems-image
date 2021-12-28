data "vsphere_content_library" "library" {
  name = var.vsphere_content_library
}

resource "vsphere_content_library_item" "template" {
  name        = var.template_name
  description = "Windows template with OS 11 instsalled. Use for OutSystems platform, front end, and LifeTime servers"
  library_id  = data.vsphere_content_library.library.id
}
