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
    public_ip_address_id = azurerm_public_ip.example.id
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
    custom_data          = file("files/ConfigureRemotingForAnsible.bat")
  }

  os_profile_windows_config {
    provision_vm_agent = true

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.azure_vm_admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.azure_vm_admin_username}</Username></AutoLogon>"
    }

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file("files/FirstLogonCommands.xml")
    }
  }
}

resource "azurerm_public_ip" "example" {
  name                  = "vc2go_server1_pip"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  allocation_method     = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "vc2go_server1_nsg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow_remote_ssh_in_all"
  resource_group_name         = azurerm_resource_group.example.name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefixes     = ["0.0.0.0/0"]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
}
resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "allow_remote_rdp_in_all"
  resource_group_name         = azurerm_resource_group.example.name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 3389
  source_address_prefixes     = ["0.0.0.0/0"]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}
