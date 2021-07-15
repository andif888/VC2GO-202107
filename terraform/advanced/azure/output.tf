data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.example.name
  resource_group_name = azurerm_virtual_machine.example.resource_group_name
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("../_shared/ansible_inventory.tmpl",
 {
  hostnames         = ["vc2go-srv1"],
  ansible_hosts     = [data.azurerm_public_ip.example.ip_address],
  is_windows_image  = true
 }
 )
 filename = "../../../ansible/advanced/environments/${basename(path.cwd)}/inventory/dynamic_inventory"

 depends_on = [azurerm_virtual_machine.example]
}

output "vm_name" {
  value = azurerm_virtual_machine.example.name
}

output "vm_ip" {
  value = data.azurerm_public_ip.example.ip_address
}
