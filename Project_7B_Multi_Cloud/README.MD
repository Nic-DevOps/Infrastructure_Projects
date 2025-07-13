# Multi-Cloud VM Provisioner

A Terraform-based infrastructure-as-code project for provisioning virtual machines across multiple cloud providers (AWS, Azure, and GCP) with consistent configuration and management.

## 🚀 Features

- **Multi-Cloud Support**: Deploy VMs across AWS, Azure, and GCP simultaneously
- **Modular Architecture**: Reusable Terraform modules for each cloud provider
- **Consistent Interface**: Standardized variables and outputs across all clouds
- **Security Best Practices**: SSH key management, security groups, and encrypted storage
- **Automated Deployment**: Scripts for easy deployment and management
- **Environment Support**: Separate configurations for dev, staging, and production
- **Validation Tools**: Built-in validation and formatting checks

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Multi-Cloud VM Provisioner               │
├─────────────────────────────────────────────────────────────┤
│  Main Terraform Configuration                               │
│  ├── Provider Management                                    │
│  ├── Variable Standardization                               │
│  └── Output Aggregation                                     │
├─────────────────────────────────────────────────────────────┤
│  Cloud Provider Modules                                     │
│  ├── AWS Module     ├── Azure Module    ├── GCP Module      │
│  │   ├── VPC        │   ├── VNet        │   ├── VPC         │
│  │   ├── Subnet     │   ├── Subnet      │   ├── Subnet      │
│  │   ├── Security   │   ├── NSG         │   ├── Firewall    │
│  │   └── EC2        │   └── VM          │   └── Instance    │
├─────────────────────────────────────────────────────────────┤
│  Supporting Components                                      │
│  ├── SSH Key Management                                     │
│  ├── Security Groups/Firewall Rules                         │
│  ├── Automation Scripts                                     │
│  └── Validation Tools                                       │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Git](https://git-scm.com/)

### Optional Tools (Recommended)
- [AWS CLI](https://aws.amazon.com/cli/) - for AWS authentication
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) - for Azure authentication
- [Google Cloud CLI](https://cloud.google.com/sdk/gcloud) - for GCP authentication
- [jq](https://stedolan.github.io/jq/) - for JSON processing

### Cloud Provider Requirements

#### AWS
- AWS account with appropriate permissions
- AWS CLI configured or environment variables set:
  ```bash
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-key"
  export AWS_DEFAULT_REGION="us-west-2"
  ```

#### Azure
- Azure subscription with appropriate permissions
- Azure CLI logged in:
  ```bash
  az login
  ```

#### GCP
- GCP project with appropriate APIs enabled
- Service account key or gcloud authentication:
  ```bash
  gcloud auth login
  gcloud config set project YOUR-PROJECT-ID
  ```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd multi-cloud-vm-provisioner
```

### 2. Set Up Configuration
```bash
# Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit configuration with your settings
vi terraform.tfvars
```

### 3. Generate SSH Keys (Optional)
```bash
# Generate SSH key pair
./scripts/setup-keys.sh

# Or use existing keys by updating terraform.tfvars
```

### 4. Validate Configuration
```bash
# Run validation checks
./scripts/validate.sh
```

### 5. Deploy Infrastructure
```bash
# Deploy to dev environment
./scripts/deploy.sh dev

# Deploy with auto-approval
./scripts/deploy.sh dev --auto-approve
```

### 6. Access Your VMs
```bash
# Get connection information
terraform output

# Connect to AWS instance
ssh -i ~/.ssh/id_rsa ubuntu@<aws-public-ip>

# Connect to Azure instance
ssh -i ~/.ssh/id_rsa ubuntu@<azure-public-ip>

# Connect to GCP instance
ssh -i ~/.ssh/id_rsa ubuntu@<gcp-public-ip>
```

## ⚙️ Configuration

### Main Configuration File (terraform.tfvars)

```hcl
# Project Settings
project_name = "my-multi-cloud-project"
environment  = "dev"
owner       = "devops-team"

# Cloud Provider Selection
deploy_aws   = true
deploy_azure = true
deploy_gcp   = true

# AWS Configuration
aws_region        = "us-west-2"
aws_instance_type = "t3.micro"

# Azure Configuration
azure_region  = "West US 2"
azure_vm_size = "Standard_B1s"

# GCP Configuration
gcp_project_id   = "your-gcp-project-id"
gcp_region       = "us-west1"
gcp_zone         = "us-west1-a"
gcp_machine_type = "e2-micro"

# SSH Configuration
ssh_public_key_path = "~/.ssh/id_rsa.pub"
ssh_username        = "ubuntu"

# Security Configuration
allowed_cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
```

### Environment-Specific Configurations

For different environments, create separate tfvars files:

```bash
# Development
terraform apply -var-file="environments/dev/terraform.tfvars"

# Staging
terraform apply -var-file="environments/staging/terraform.tfvars"

# Production
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 🔧 Available Scripts

### Deployment Scripts
- `./scripts/deploy.sh [environment]` - Deploy infrastructure
- `./scripts/destroy.sh [environment]` - Destroy infrastructure
- `./scripts/validate.sh` - Validate configuration
- `./scripts/setup-keys.sh [key-name]` - Generate SSH keys

### Script Options
- `--auto-approve` - Skip confirmation prompts
- `[environment]` - Target environment (dev/staging/prod)

## 📊 Outputs

The project provides comprehensive outputs for all deployed resources:

```json
{
  "aws_instance_info": {
    "value": {
      "instance_id": "i-1234567890abcdef0",
      "public_ip": "54.123.45.67",
      "private_ip": "10.0.1.100",
      "ssh_command": "ssh -i ~/.ssh/id_rsa ubuntu@54.123.45.67"
    }
  },
  "azure_instance_info": {
    "value": {
      "instance_id": "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/...",
      "public_ip": "20.123.45.67",
      "private_ip": "10.1.1.100",
      "ssh_command": "ssh -i ~/.ssh/id_rsa ubuntu@20.123.45.67"
    }
  },
  "gcp_instance_info": {
    "value": {
      "instance_id": "projects/.../zones/.../instances/...",
      "public_ip": "35.123.45.67",
      "private_ip": "10.2.1.100",
      "ssh_command": "ssh -i ~/.ssh/id_rsa ubuntu@35.123.45.67"
    }
  }
}
```

## 🔒 Security Considerations

### Best Practices Implemented
- **SSH Key Authentication**: No password-based authentication
- **Security Groups**: Proper firewall rules for each cloud
- **Encrypted Storage**: Root volumes are encrypted
- **Least Privilege**: Minimal required permissions
- **Network Segmentation**: Isolated VPCs/VNets per cloud

### Production Hardening
1. **Restrict CIDR Blocks**: Limit `allowed_cidr_blocks` to specific IP ranges
2. **Use Private Subnets**: Deploy instances in private subnets with NAT gateways
3. **Enable Monitoring**: Add CloudWatch, Azure Monitor, or Stackdriver
4. **Implement Backup**: Add automated backup solutions
5. **Use Remote State**: Configure remote state backend with locking

## 🧪 Testing

### Manual Testing
```bash
# Validate configuration
./scripts/validate.sh

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Test SSH connectivity
ssh -i ~/.ssh/id_rsa ubuntu@<instance-ip> "echo 'Connection successful'"
```

### Automated Testing
```bash
# Run unit tests (requires Go and Terratest)
cd tests/unit
go test -v

# Run integration tests
cd tests/integration
go test -v
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Authentication Errors
**Problem**: Provider authentication failures
**Solution**: 
- Verify cloud provider CLI authentication
- Check environment variables
- Validate service account permissions

#### 2. SSH Connection Issues
**Problem**: Cannot connect to instances
**Solution**:
- Verify SSH key path in terraform.tfvars
- Check security group rules
- Confirm instance is in running state

#### 3. Terraform State Issues
**Problem**: State file conflicts or corruption
**Solution**:
- Use remote state backend
- Implement state locking
- Regular state backups

#### 4. Resource Quota Limits
**Problem**: Cloud provider quota exceeded
**Solution**:
- Check account limits
- Request quota increases
- Use smaller instance types

### Debug Mode
```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
terraform plan -var-file="terraform.tfvars"
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

### Development Guidelines
- Follow Terraform best practices
- Update documentation
- Add tests for new features
- Use consistent naming conventions

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Check the [troubleshooting guide](docs/troubleshooting.md)
- Review the [architecture documentation](docs/architecture.md)
- Open an issue in the repository

## 🏷️ Version History

- **v1.0.0**: Initial release with AWS, Azure, and GCP support
- **v1.1.0**: Added environment management and validation scripts
- **v1.2.0**: Enhanced security features and monitoring

---
