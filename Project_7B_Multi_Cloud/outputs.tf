output "aws_instance_info" {
  description = "AWS instance information"
  value = var.deploy_aws ? {
    instance_id = module.aws_vm[0].instance_id
    public_ip   = module.aws_vm[0].public_ip
    private_ip  = module.aws_vm[0].private_ip
    ssh_command = "ssh -i ~/.ssh/id_rsa ${var.ssh_username}@${module.aws_vm[0].public_ip}"
  } : null
}

output "azure_instance_info" {
  description = "Azure instance information"
  value = var.deploy_azure ? {
    instance_id = module.azure_vm[0].instance_id
    public_ip   = module.azure_vm[0].public_ip
    private_ip  = module.azure_vm[0].private_ip
    ssh_command = "ssh -i ~/.ssh/id_rsa ${var.ssh_username}@${module.azure_vm[0].public_ip}"
  } : null
}

output "gcp_instance_info" {
  description = "GCP instance information"
  value = var.deploy_gcp ? {
    instance_id = module.gcp_vm[0].instance_id
    public_ip   = module.gcp_vm[0].public_ip
    private_ip  = module.gcp_vm[0].private_ip
    ssh_command = "ssh -i ~/.ssh/id_rsa ${var.ssh_username}@${module.gcp_vm[0].public_ip}"
  } : null
}

output "ssh_private_key" {
  description = "Generated SSH private key (sensitive)"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project_name = var.project_name
    environment  = var.environment
    deployed_clouds = compact([
      var.deploy_aws ? "aws" : "",
      var.deploy_azure ? "azure" : "",
      var.deploy_gcp ? "gcp" : ""
    ])
    total_instances = sum([
      var.deploy_aws ? 1 : 0,
      var.deploy_azure ? 1 : 0,
      var.deploy_gcp ? 1 : 0
    ])
  }
}
