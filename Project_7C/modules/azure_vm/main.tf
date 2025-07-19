###############################################################################
# Azure VM Module – B1 minimal instance.                                   #
###############################################################################

variable "azure_region" { type = string }
variable "azure_vm_size" { type = string }
variable "admin_username" { type = string }
variable "ssh_pub_key" { type = string }
variable "tags" { type = map(string) }
variable "image" { type = map(string) }




###############################################################################
# Networking – VPC + Subnet                                                   #
###############################################################################


resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name}"
  location = var.azure_region
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.name}"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}

###############################################################################
# Security Group – allows SSH (22) and optional HTTP (80).                    #
###############################################################################

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${local.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${local.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


###############################################################################
# Azure B1 Instance                                                                 #
###############################################################################

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-${local.name}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = var.azure_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_pub_key
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  os_disk {
    caching              = "ReadWrite"    # or "ReadOnly"
    storage_account_type = "Standard_LRS" # free-tier friendly; use Premium_LRS for SSD
    disk_size_gb         = 30             # optional – default size depends on image
  }

  tags = var.tags
}

locals {
  name = "${var.tags["project"]}-${var.tags["environment"]}"
}

###############################################################################
# Outputs                                                                     #
###############################################################################


output "public_ip" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public IP for SSH"
}