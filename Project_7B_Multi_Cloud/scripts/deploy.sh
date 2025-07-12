#!/bin/bash
set -euo pipefail

# Multi-Cloud VM Provisioner Deployment Script
# Usage: ./scripts/deploy.sh [environment] [--auto-approve]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENVIRONMENT="${1:-dev}"
AUTO_APPROVE="${2:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if environment is valid
validate_environment() {
    if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
        log_error "Invalid environment: $ENVIRONMENT"
        log_info "Valid environments: dev, staging, prod"
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if terraform is installed
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform is not installed"
        exit 1
    fi
    
    # Check terraform version
    TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')
    log_info "Terraform version: $TERRAFORM_VERSION"
    
    # Check if required files exist
    if [[ ! -f "$PROJECT_ROOT/terraform.tfvars" ]]; then
        log_warning "terraform.tfvars not found"
        log_info "Please create terraform.tfvars from terraform.tfvars.example"
        
        if [[ -f "$PROJECT_ROOT/terraform.tfvars.example" ]]; then
            log_info "Copying terraform.tfvars.example to terraform.tfvars"
            cp "$PROJECT_ROOT/terraform.tfvars.example" "$PROJECT_ROOT/terraform.tfvars"
            log_warning "Please edit terraform.tfvars with your configuration"
            exit 1
        fi
    fi
    
    # Check SSH key
    SSH_KEY_PATH=$(grep ssh_public_key_path "$PROJECT_ROOT/terraform.tfvars" | cut -d'"' -f2)
    if [[ -n "$SSH_KEY_PATH" ]]; then
        SSH_KEY_PATH=$(eval echo "$SSH_KEY_PATH")
        if [[ ! -f "$SSH_KEY_PATH" ]]; then
            log_warning "SSH public key not found at: $SSH_KEY_PATH"
            log_info "Generating SSH key pair..."
            ssh-keygen -t rsa -b 4096 -f "${SSH_KEY_PATH%.*}" -N "" -C "multi-cloud-vm-$ENVIRONMENT"
            log_success "SSH key pair generated"
        fi
    fi
}

# Initialize Terraform
terraform_init() {
    log_info "Initializing Terraform..."
    cd "$PROJECT_ROOT"
    terraform init
    log_success "Terraform initialized"
}

# Validate Terraform configuration
terraform_validate() {
    log_info "Validating Terraform configuration..."
    terraform validate
    log_success "Terraform configuration is valid"
}

# Plan Terraform deployment
terraform_plan() {
    log_info "Planning Terraform deployment for environment: $ENVIRONMENT"
    terraform plan -var-file="terraform.tfvars" -out="terraform.tfplan"
    log_success "Terraform plan completed"
}

# Apply Terraform deployment
terraform_apply() {
    log_info "Applying Terraform deployment..."
    
    if [[ "$AUTO_APPROVE" == "--auto-approve" ]]; then
        terraform apply -auto-approve "terraform.tfplan"
    else
        terraform apply "terraform.tfplan"
    fi
    
    log_success "Terraform deployment completed"
}

# Display outputs
show_outputs() {
    log_info "Deployment outputs:"
    terraform output -json | jq .

    log_info "SSH connection commands:"
    terraform output -json | jq -r '
        if .aws_instance_info.value then
            "AWS: " + .aws_instance_info.value.ssh_command
        else empty end,
        if .azure_instance_info.value then
            "Azure: " + .azure_instance_info.value.ssh_command
        else empty end,
        if .gcp_instance_info.value then
            "GCP: " + .gcp_instance_info.value.ssh_command
        else empty end
    '
}

# Main deployment function
main() {
    log_info "Starting Multi-Cloud VM deployment..."
    log_info "Environment: $ENVIRONMENT"
    
    validate_environment
    check_prerequisites
    terraform_init
    terraform_validate
    terraform_plan
    terraform_apply
    show_outputs
    
    log_success "Deployment completed successfully!"
}

# Run main function
main "$@"
