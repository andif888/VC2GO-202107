provider "vsphere" {
  user              = var.vsphere_user
  password          = var.vsphere_password
  vsphere_server    = var.vsphere_server
  # if you have a self-signed cert
  # allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name             = "dscu"
}

# data "vsphere_compute_cluster" "cluster" {
#   name             = "cluster1"
#   datacenter_id    = "${data.vsphere_datacenter.dc.id}"
# }

data "vsphere_host" "host" {
  name             = "esx.lab.controlup.eu"
  datacenter_id    = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name             = "ds_ssd3"
  datacenter_id    = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name             = "VM Network"
  datacenter_id    = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_windows" {
  name             = "tpl-windows-2019"
  datacenter_id    = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "vc2go_server1_vm"
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus         = 2
  memory           = 2048
  guest_id         = data.vsphere_virtual_machine.template_windows.guest_id

  network_interface {
    network_id     = data.vsphere_network.network.id
  }

  disk {
    label          = "disk0"
    size           = data.vsphere_virtual_machine.template_windows.disks.0.size
  }

  cdrom {
    client_device  = true
  }

  clone {
    template_uuid  = data.vsphere_virtual_machine.template_windows.id
    linked_clone   = false
  }
}
