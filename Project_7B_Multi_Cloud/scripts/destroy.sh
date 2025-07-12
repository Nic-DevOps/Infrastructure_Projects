# =============================================================================
# scripts/destroy.sh
# =============================================================================

#!/bin/bash
set -euo pipefail

# Multi-Cloud VM Provisioner Destroy Script
# Usage: ./scripts/destroy.sh [environment] [--auto-approve]

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

# Confirmation prompt
confirm_destroy() {
    if [[ "$AUTO_APPROVE" != "--auto-approve" ]]; then
        log_warning "This will destroy all resources in environment: $ENVIRONMENT"
        read -p "Are you sure you want to continue? (yes/no): " -r
        if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
            log_info "Destruction cancelled"
            exit 0
        fi
    fi
}

# Main destroy function
main() {
    log_info "Starting Multi-Cloud VM destruction..."
    log_info "Environment: $ENVIRONMENT"
    
    confirm_destroy
    
    cd "$PROJECT_ROOT"
    
    log_info "Planning destruction..."
    terraform plan -destroy -var-file="terraform.tfvars" -out="destroy.tfplan"
    
    log_info "Destroying resources..."
    if [[ "$AUTO_APPROVE" == "--auto-approve" ]]; then
        terraform apply -auto-approve "destroy.tfplan"
    else
        terraform apply "destroy.tfplan"
    fi
    
    # Clean up plan files
    rm -f terraform.tfplan destroy.tfplan
    
    log_success "All resources destroyed successfully!"
}

# Run main function
main "$@"