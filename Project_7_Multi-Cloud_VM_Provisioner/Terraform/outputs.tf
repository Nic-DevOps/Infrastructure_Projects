output "aws_public_ips" {
  value = module.aws_vm.public_ips
}

output "gcp_public_ips" {
  value = module.gcp_vm.public_ips
}

output "azure_public_ips" {
  value = module.azure_vm.public_ips
}
