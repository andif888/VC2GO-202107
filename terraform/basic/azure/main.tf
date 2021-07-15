provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

resource "azurerm_resource_group" "example" {
  name                   = "vc2go_rg"
  location               = "Germany West Central"
}

resource "azurerm_virtual_network" "example" {
  name                   = "vc2go_network"
  address_space          = ["10.0.0.0/16"]
  location               = azurerm_resource_group.example.location
  resource_group_name    = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                   = "internal"
  resource_group_name    = azurerm_resource_group.example.name
  virtual_network_name   = azurerm_virtual_network.example.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                   = "vc2go_server1_nic"
  location               = azurerm_resource_group.example.location
  resource_group_name    = azurerm_resource_group.example.name

  ip_configuration {
    name                 = "internal"
    subnet_id            = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                   = "vc2go_server1_vm"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  vm_size                = "Standard_B2s"
  network_interface_ids  = [azurerm_network_interface.example.id]
  delete_os_disk_on_termination = true

  storage_os_disk {
    name                 = "vc2go_server1_osdisk"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  storage_image_reference {
    publisher            = "MicrosoftWindowsServer"
    offer                = "WindowsServer"
    sku                  = "2019-Datacenter"
    version              = "latest"
  }

  os_profile {
    computer_name        = "vc2go-srv1"
    admin_username       = var.azure_vm_admin_username
    admin_password       = var.azure_vm_admin_password
  }
  
  os_profile_windows_config {
    provision_vm_agent = true
  }
}
