###############################################################################
# Azure VM Module – builds B1s VM in its own resource group & VNet.            #
###############################################################################

variable "azure_region" {}
variable "ssh_pub_key" {}
variable "tags" {
  type = map(string)
}

# Resource Group – logical container.
resource "azurerm_resource_group" "vm_rg" {
  name     = "${var.tags.project}-rg"
  location = var.azure_region
  tags     = var.tags
}

# Virtual Network & Subnet.
resource "azurerm_virtual_network" "vm_vnet" {
  name                = "${var.tags.project}-vnet"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.vm_rg.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = ["10.30.1.0/24"]
}

# Public IP.
resource "azurerm_public_ip" "vm_pip" {
  name                = "${var.tags.project}-pip"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
  tags                = var.tags
}

# Network Interface.
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.tags.project}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }

  tags = var.tags
}

# Linux VM.
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.tags.project}-azure-vm"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  size                = "Standard_B1s"      # Low‑cost tier

  admin_username = "ubuntu"

  admin_ssh_key {
    username   = "ubuntu"
    public_key = var.ssh_pub_key
  }

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = var.tags
}

output "public_ip" {
  value = azurerm_public_ip.vm_pip.ip_address
}