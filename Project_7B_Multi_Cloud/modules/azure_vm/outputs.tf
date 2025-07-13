output "instance_id" {
  description = "ID of the Azure VM"
  value       = azurerm_linux_virtual_machine.main.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = azurerm_network_interface.main.private_ip_address
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = azurerm_public_ip.main.fqdn
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.public.id
}

output "network_security_group_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.main.id
}

output "vm_size" {
  description = "Size of the VM"
  value       = azurerm_linux_virtual_machine.main.size
}

output "location" {
  description = "Azure region of the resources"
  value       = azurerm_resource_group.main.location
}