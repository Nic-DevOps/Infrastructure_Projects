output "aws_public_ips" {
  value = module.vm_aws.public_ips
}

output "gcp_public_ips" {
  value = module.vm_gcp.public_ips
}

output "azure_public_ips" {
  value = module.vm_az.public_ips
}
