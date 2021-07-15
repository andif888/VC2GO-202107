variable "vsphere_server" {
  description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local or IP address"
  default = "vcenter.lab.controlup.eu"
}

variable "vsphere_user" {
  description = "vSphere Admin Username"
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "vSphere Admin Password"
  default = "YourSecretPassword"
}
