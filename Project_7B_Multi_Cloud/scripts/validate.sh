# =============================================================================
# scripts/validate.sh
# =============================================================================

#!/bin/bash
set -euo pipefail

# Multi-Cloud VM Provisioner Validation Script
# Usage: ./scripts/validate.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

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

# Check tool versions
check_tools() {
    log_info "Checking required tools..."
    
    # Terraform
    if command -v terraform &> /dev/null; then
        TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')
        log_success "Terraform: $TERRAFORM_VERSION"
    else
        log_error "Terraform not found"
        return 1
    fi
    
    # AWS CLI
    if command -v aws &> /dev/null; then
        AWS_VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
        log_success "AWS CLI: $AWS_VERSION"
    else
        log_warning "AWS CLI not found (optional)"
    fi
    
    # Azure CLI
    if command -v az &> /dev/null; then
        AZURE_VERSION=$(az version --output json | jq -r '.["azure-cli"]')
        log_success "Azure CLI: $AZURE_VERSION"
    else
        log_warning "Azure CLI not found (optional)"
    fi
    
    # Google Cloud CLI
    if command -v gcloud &> /dev/null; then
        GCLOUD_VERSION=$(gcloud version --format="value(Google Cloud SDK)")
        log_success "Google Cloud CLI: $GCLOUD_VERSION"
    else
        log_warning "Google Cloud CLI not found (optional)"
    fi
    
    # jq
    if command -v jq &> /dev/null; then
        JQ_VERSION=$(jq --version)
        log_success "jq: $JQ_VERSION"
    else
        log_warning "jq not found (recommended for output parsing)"
    fi
}

# Validate Terraform configuration
validate_terraform() {
    log_info "Validating Terraform configuration..."
    
    cd "$PROJECT_ROOT"
    
    # Initialize if needed
    if [[ ! -d ".terraform" ]]; then
        log_info "Initializing Terraform..."
        terraform init
    fi
    
    # Validate syntax
    if terraform validate; then
        log_success "Terraform configuration is valid"
    else
        log_error "Terraform validation failed"
        return 1
    fi
    
    # Format check
    if terraform fmt -check -recursive; then
        log_success "Terraform formatting is correct"
    else
        log_warning "Terraform formatting issues found"
        log_info "Run 'terraform fmt -recursive' to fix formatting"
    fi
}

# Check configuration files
check_config() {
    log_info "Checking configuration files..."
    
    # Check terraform.tfvars
    if [[ -f "$PROJECT_ROOT/terraform.tfvars" ]]; then
        log_success "terraform.tfvars found"
        
        # Check for required variables
        REQUIRED_VARS=("gcp_project_id")
        for var in "${REQUIRED_VARS[@]}"; do
            if grep -q "^$var" "$PROJECT_ROOT/terraform.tfvars"; then
                log_success "Required variable '$var' is set"
            else
                log_error "Required variable '$var' not found in terraform.tfvars"
            fi
        done
    else
        log_warning "terraform.tfvars not found"
        log_info "Copy terraform.tfvars.example to terraform.tfvars and configure"
    fi
    
    # Check SSH key
    if [[ -f "$PROJECT_ROOT/terraform.tfvars" ]]; then
        SSH_KEY_PATH=$(grep ssh_public_key_path "$PROJECT_ROOT/terraform.tfvars" | cut -d'"' -f2)
        if [[ -n "$SSH_KEY_PATH" ]]; then
            SSH_KEY_PATH=$(eval echo "$SSH_KEY_PATH")
            if [[ -f "$SSH_KEY_PATH" ]]; then
                log_success "SSH public key found at: $SSH_KEY_PATH"
            else
                log_warning "SSH public key not found at: $SSH_KEY_PATH"
            fi
        fi
    fi
}

# Check cloud provider authentication
check_auth() {
    log_info "Checking cloud provider authentication..."
    
    # AWS
    if command -v aws &> /dev/null; then
        if aws sts get-caller-identity &> /dev/null; then
            log_success "AWS authentication configured"
        else
            log_warning "AWS authentication not configured"
        fi
    fi
    
    # Azure
    if command -v az &> /dev/null; then
        if az account show &> /dev/null; then
            log_success "Azure authentication configured"
        else
            log_warning "Azure authentication not configured"
        fi
    fi
    
    # GCP
    if command -v gcloud &> /dev/null; then
        if gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -1 &> /dev/null; then
            log_success "GCP authentication configured"
        else
            log_warning "GCP authentication not configured"
        fi
    fi
}

# Main validation function
main() {
    log_info "Starting Multi-Cloud VM Provisioner validation..."
    
    check_tools
    validate_terraform
    check_config
    check_auth
    
    log_success "Validation completed!"
}

# Run main function
main "$@"