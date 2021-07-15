### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("../_shared/ansible_inventory.tmpl",
  {
   hostnames          = ["vc2go-srv1"],
   ansible_hosts      = [vsphere_virtual_machine.vm.default_ip_address]
   is_windows_image   = true
  }
  )
 filename = "../../../ansible/advanced/environments/${basename(path.cwd)}/inventory/dynamic_inventory"
}


output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}

output "vm_ip" {
  value = vsphere_virtual_machine.vm.default_ip_address
}
