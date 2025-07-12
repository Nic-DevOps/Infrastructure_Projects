#!/bin/bash
set -euo pipefail

# Multi-Cloud VM Provisioner SSH Key Setup Script
# Usage: ./scripts/setup-keys.sh [key-name] [--force]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
KEY_NAME="${1:-multi-cloud-vm}"
FORCE_FLAG="${2:-}"
KEY_DIR="$HOME/.ssh"
PRIVATE_KEY="$KEY_DIR/$KEY_NAME"
PUBLIC_KEY="$KEY_DIR/$KEY_NAME.pub"

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

# Display usage information
show_usage() {
    cat << EOF
Multi-Cloud VM SSH Key Setup Script

Usage: $0 [key-name] [--force]

Arguments:
  key-name    Name for the SSH key pair (default: multi-cloud-vm)
  --force     Force overwrite existing keys without prompting

Examples:
  $0                          # Generate key with default name
  $0 my-cloud-key            # Generate key with custom name
  $0 my-cloud-key --force    # Force overwrite existing key

The script will:
1. Create SSH directory if it doesn't exist
2. Generate RSA 4096-bit key pair
3. Set proper file permissions
4. Display public key content
5. Update terraform.tfvars with key path
EOF
}

# Validate key name
validate_key_name() {
    if [[ ! "$KEY_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid key name: $KEY_NAME"
        log_info "Key name must contain only letters, numbers, hyphens, and underscores"
        exit 1
    fi
    
    if [[ ${#KEY_NAME} -gt 64 ]]; then
        log_error "Key name too long: $KEY_NAME (max 64 characters)"
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if ssh-keygen is available
    if ! command -v ssh-keygen &> /dev/null; then
        log_error "ssh-keygen is not installed"
        exit 1
    fi
    
    # Check if we can write to SSH directory
    if [[ ! -d "$KEY_DIR" ]]; then
        log_info "Creating SSH directory: $KEY_DIR"
        mkdir -p "$KEY_DIR"
        chmod 700 "$KEY_DIR"
    fi
    
    if [[ ! -w "$KEY_DIR" ]]; then
        log_error "Cannot write to SSH directory: $KEY_DIR"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Check if key already exists
check_existing_key() {
    if [[ -f "$PRIVATE_KEY" || -f "$PUBLIC_KEY" ]]; then
        log_warning "SSH key already exists:"
        [[ -f "$PRIVATE_KEY" ]] && log_info "Private key: $PRIVATE_KEY"
        [[ -f "$PUBLIC_KEY" ]] && log_info "Public key: $PUBLIC_KEY"
        
        if [[ "$FORCE_FLAG" == "--force" ]]; then
            log_warning "Force flag specified, overwriting existing key"
            return 0
        fi
        
        read -p "Overwrite existing key? (y/n): " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Keeping existing key"
            display_existing_key
            exit 0
        fi
        
        log_info "Removing existing key files"
        rm -f "$PRIVATE_KEY" "$PUBLIC_KEY"
    fi
}

# Display existing key information
display_existing_key() {
    if [[ -f "$PUBLIC_KEY" ]]; then
        log_info "Existing public key content:"
        cat "$PUBLIC_KEY"
        
        log_info "Key fingerprint:"
        ssh-keygen -lf "$PUBLIC_KEY" 2>/dev/null || log_warning "Could not generate fingerprint"
        
        log_info "Key details:"
        ssh-keygen -lf "$PUBLIC_KEY" -v 2>/dev/null || log_warning "Could not get key details"
    fi
}

# Generate SSH key pair
generate_key_pair() {
    log_info "Generating SSH key pair..."
    log_info "Key name: $KEY_NAME"
    log_info "Private key: $PRIVATE_KEY"
    log_info "Public key: $PUBLIC_KEY"
    
    # Generate the key pair
    if ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N "" -C "$KEY_NAME@multi-cloud-vm-$(date +%Y%m%d)"; then
        log_success "SSH key pair generated successfully"
    else
        log_error "Failed to generate SSH key pair"
        exit 1
    fi
    
    # Set proper permissions
    chmod 600 "$PRIVATE_KEY"
    chmod 644 "$PUBLIC_KEY"
    
    log_success "File permissions set correctly"
}

# Validate generated keys
validate_keys() {
    log_info "Validating generated keys..."
    
    # Check if files exist
    if [[ ! -f "$PRIVATE_KEY" ]]; then
        log_error "Private key not found: $PRIVATE_KEY"
        exit 1
    fi
    
    if [[ ! -f "$PUBLIC_KEY" ]]; then
        log_error "Public key not found: $PUBLIC_KEY"
        exit 1
    fi
    
    # Check file permissions
    PRIVATE_PERMS=$(stat -c %a "$PRIVATE_KEY" 2>/dev/null || stat -f %A "$PRIVATE_KEY" 2>/dev/null)
    PUBLIC_PERMS=$(stat -c %a "$PUBLIC_KEY" 2>/dev/null || stat -f %A "$PUBLIC_KEY" 2>/dev/null)
    
    if [[ "$PRIVATE_PERMS" != "600" ]]; then
        log_warning "Private key permissions: $PRIVATE_PERMS (should be 600)"
    else
        log_success "Private key permissions: $PRIVATE_PERMS"
    fi
    
    if [[ "$PUBLIC_PERMS" != "644" ]]; then
        log_warning "Public key permissions: $PUBLIC_PERMS (should be 644)"
    else
        log_success "Public key permissions: $PUBLIC_PERMS"
    fi
    
    # Test key validation
    if ssh-keygen -lf "$PUBLIC_KEY" &>/dev/null; then
        log_success "Public key is valid"
    else
        log_error "Public key validation failed"
        exit 1
    fi
    
    log_success "Key validation completed"
}

# Display key information
display_key_info() {
    log_info "SSH Key Information:"
    echo "=================="
    
    log_info "Private key: $PRIVATE_KEY"
    log_info "Public key: $PUBLIC_KEY"
    
    echo ""
    log_info "Public key content:"
    cat "$PUBLIC_KEY"
    
    echo ""
    log_info "Key fingerprint:"
    ssh-keygen -lf "$PUBLIC_KEY"
    
    echo ""
    log_info "Key randomart:"
    ssh-keygen -lf "$PUBLIC_KEY" -v
}

# Update terraform.tfvars file
update_terraform_vars() {
    TFVARS_FILE="$PROJECT_ROOT/terraform.tfvars"
    TFVARS_EXAMPLE="$PROJECT_ROOT/terraform.tfvars.example"
    
    log_info "Updating Terraform configuration..."
    
    # Create terraform.tfvars if it doesn't exist
    if [[ ! -f "$TFVARS_FILE" ]]; then
        if [[ -f "$TFVARS_EXAMPLE" ]]; then
            log_info "Creating terraform.tfvars from example"
            cp "$TFVARS_EXAMPLE" "$TFVARS_FILE"
        else
            log_warning "terraform.tfvars.example not found, creating minimal config"
            cat > "$TFVARS_FILE" << EOF
# SSH Configuration
ssh_public_key_path = "$PUBLIC_KEY"
ssh_username        = "ubuntu"
EOF
        fi
    fi
    
    # Update SSH key path in terraform.tfvars
    if grep -q "ssh_public_key_path" "$TFVARS_FILE"; then
        # Replace existing line
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s|ssh_public_key_path.*|ssh_public_key_path = \"$PUBLIC_KEY\"|" "$TFVARS_FILE"
        else
            # Linux
            sed -i "s|ssh_public_key_path.*|ssh_public_key_path = \"$PUBLIC_KEY\"|" "$TFVARS_FILE"
        fi
        log_success "Updated existing ssh_public_key_path in terraform.tfvars"
    else
        # Add new line
        echo "ssh_public_key_path = \"$PUBLIC_KEY\"" >> "$TFVARS_FILE"
        log_success "Added ssh_public_key_path to terraform.tfvars"
    fi
    
    log_info "Terraform configuration updated"
}

# Add key to SSH agent
add_to_ssh_agent() {
    log_info "Adding key to SSH agent..."
    
    # Check if SSH agent is running
    if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
        log_warning "SSH agent not running, skipping key addition"
        log_info "To add key manually: ssh-add $PRIVATE_KEY"
        return 0
    fi
    
    # Add key to agent
    if ssh-add "$PRIVATE_KEY" 2>/dev/null; then
        log_success "Key added to SSH agent"
    else
        log_warning "Failed to add key to SSH agent"
        log_info "To add key manually: ssh-add $PRIVATE_KEY"
    fi
}

# Display next steps
show_next_steps() {
    log_info "Next Steps:"
    echo "==========="
    echo "1. Review and update terraform.tfvars configuration"
    echo "2. Run validation: ./scripts/validate.sh"
    echo "3. Deploy infrastructure: ./scripts/deploy.sh"
    echo ""
    echo "SSH Connection Commands (after deployment):"
    echo "- AWS: ssh -i $PRIVATE_KEY ubuntu@<aws-ip>"
    echo "- Azure: ssh -i $PRIVATE_KEY ubuntu@<azure-ip>"
    echo "- GCP: ssh -i $PRIVATE_KEY ubuntu@<gcp-ip>"
    echo ""
    echo "Key Management:"
    echo "- Add to agent: ssh-add $PRIVATE_KEY"
    echo "- List keys: ssh-add -l"
    echo "- Remove key: ssh-add -d $PRIVATE_KEY"
}

# Main setup function
main() {
    # Handle help flag
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    log_info "Starting SSH key setup for Multi-Cloud VM Provisioner..."
    log_info "Key name: $KEY_NAME"
    
    validate_key_name
    check_prerequisites
    check_existing_key
    generate_key_pair
    validate_keys
    display_key_info
    update_terraform_vars
    add_to_ssh_agent
    show_next_steps
    
    log_success "SSH key setup completed successfully!"
}

# Run main function
main "$@"