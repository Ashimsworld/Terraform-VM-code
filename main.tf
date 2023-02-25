#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_nmame
  location = var.location 
  tags     = var.tags
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location 
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space 
  tags                = var.tags
} 

#Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name 
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixe
  depends_on = [
    azurerm_virtual_network.vnet
  ]
} 

#Create network interface
resource "azurerm_public_ip" "primary" {
 # count = (var.public_ip_enabled == true ? 1 : 0)

  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  allocation_method = "Dynamic"
  sku               = var.public_ip_sku
}


resource "azurerm_network_interface" "nif" {
  name                = var.network_interface_name 
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.primary.id
  }
}

#Create Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nif.id]
  vm_size               = "Standard_B2s" # 2 vCPU and 2GB RAM

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username 
    admin_password = var.admin_password 
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "development"
  }
}