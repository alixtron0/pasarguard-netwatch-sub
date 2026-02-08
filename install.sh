#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# Netwatch Subscription Template - Automatic Installer
# For Pasarguard VPN Panel
# ═══════════════════════════════════════════════════════════════

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
GITHUB_RAW_URL="https://raw.githubusercontent.com/alixtron0/pasarguard-netwatch-sub/main/sub.html"
TEMPLATES_DIR="/var/lib/pasarguard/templates"
TEMPLATE_FILE="$TEMPLATES_DIR/sub.html"
ENV_FILE="/opt/pasarguard/.env"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

# ═══════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════

print_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ██╗███████╗████████╗██╗    ██╗ █████╗ ████████╗ ║
║   ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔══██╗╚══██╔══╝ ║
║   ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║███████║   ██║    ║
║   ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██╔══██║   ██║    ║
║   ██║ ╚████║███████╗   ██║   ╚███╔███╔╝██║  ██║   ██║    ║
║   ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝    ║
║                                                           ║
║         Subscription Template Auto-Installer             ║
║                   for Pasarguard                         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_pasarguard() {
    if ! command -v pasarguard &> /dev/null; then
        log_error "Pasarguard is not installed or not in PATH"
        log_info "Please install Pasarguard first: https://github.com/pasarguard/pasarguard"
        exit 1
    fi
    log_success "Pasarguard found"
}

check_dependencies() {
    log_info "Checking dependencies..."

    local missing_deps=()

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_warning "Missing dependencies: ${missing_deps[*]}"
        log_info "Installing missing dependencies..."

        if command -v apt-get &> /dev/null; then
            apt-get update -qq
            apt-get install -y -qq "${missing_deps[@]}"
        elif command -v yum &> /dev/null; then
            yum install -y -q "${missing_deps[@]}"
        else
            log_error "Cannot install dependencies automatically. Please install: ${missing_deps[*]}"
            exit 1
        fi
    fi

    log_success "All dependencies satisfied"
}

create_backup() {
    if [ -f "$ENV_FILE" ]; then
        log_info "Creating backup of .env file..."
        cp "$ENV_FILE" "${ENV_FILE}${BACKUP_SUFFIX}"
        log_success "Backup created: ${ENV_FILE}${BACKUP_SUFFIX}"
    fi

    if [ -f "$TEMPLATE_FILE" ]; then
        log_info "Creating backup of existing template..."
        cp "$TEMPLATE_FILE" "${TEMPLATE_FILE}${BACKUP_SUFFIX}"
        log_success "Backup created: ${TEMPLATE_FILE}${BACKUP_SUFFIX}"
    fi
}

create_templates_dir() {
    log_info "Creating templates directory..."
    mkdir -p "$TEMPLATES_DIR"
    log_success "Directory created: $TEMPLATES_DIR"
}

download_template() {
    log_info "Downloading Netwatch template from GitHub..."

    if curl -fsSL -o "$TEMPLATE_FILE" "$GITHUB_RAW_URL"; then
        log_success "Template downloaded successfully"
    else
        log_error "Failed to download template from: $GITHUB_RAW_URL"
        log_info "Please check your internet connection and GitHub URL"
        exit 1
    fi

    # Set proper permissions
    chmod 644 "$TEMPLATE_FILE"
    log_success "File permissions set"
}

configure_env() {
    log_info "Configuring Pasarguard environment..."

    if [ ! -f "$ENV_FILE" ]; then
        log_error "Pasarguard .env file not found at: $ENV_FILE"
        exit 1
    fi

    # Check if variables already exist (commented or uncommented)
    local has_templates_dir=$(grep -c "^#\?CUSTOM_TEMPLATES_DIRECTORY=" "$ENV_FILE" || true)
    local has_template_name=$(grep -c "^#\?SUBSCRIPTION_PAGE_TEMPLATE=" "$ENV_FILE" || true)

    # Create temporary file
    local temp_file=$(mktemp)

    if [ "$has_templates_dir" -gt 0 ]; then
        # Uncomment and update existing line
        sed "s|^#\?CUSTOM_TEMPLATES_DIRECTORY=.*|CUSTOM_TEMPLATES_DIRECTORY=$TEMPLATES_DIR/|g" "$ENV_FILE" > "$temp_file"
        mv "$temp_file" "$ENV_FILE"
        log_success "Updated CUSTOM_TEMPLATES_DIRECTORY"
    else
        # Add new line
        echo "CUSTOM_TEMPLATES_DIRECTORY=$TEMPLATES_DIR/" >> "$ENV_FILE"
        log_success "Added CUSTOM_TEMPLATES_DIRECTORY"
    fi

    temp_file=$(mktemp)

    if [ "$has_template_name" -gt 0 ]; then
        # Uncomment and update existing line
        sed "s|^#\?SUBSCRIPTION_PAGE_TEMPLATE=.*|SUBSCRIPTION_PAGE_TEMPLATE=sub.html|g" "$ENV_FILE" > "$temp_file"
        mv "$temp_file" "$ENV_FILE"
        log_success "Updated SUBSCRIPTION_PAGE_TEMPLATE"
    else
        # Add new line
        echo "SUBSCRIPTION_PAGE_TEMPLATE=sub.html" >> "$ENV_FILE"
        log_success "Added SUBSCRIPTION_PAGE_TEMPLATE"
    fi

    log_success "Environment configuration complete"
}

restart_pasarguard() {
    log_info "Restarting Pasarguard service..."

    if pasarguard restart; then
        log_success "Pasarguard restarted successfully"
    else
        log_error "Failed to restart Pasarguard"
        log_info "Please restart manually: pasarguard restart"
        exit 1
    fi
}

print_success_message() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║   ✓ Installation completed successfully!                 ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Template location:${NC} $TEMPLATE_FILE"
    echo -e "${CYAN}Configuration:${NC} $ENV_FILE"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Visit your Pasarguard subscription page"
    echo -e "  2. Customize the template if needed:"
    echo -e "     ${CYAN}nano $TEMPLATE_FILE${NC}"
    echo -e "  3. After editing, restart Pasarguard:"
    echo -e "     ${CYAN}pasarguard restart${NC}"
    echo ""
    echo -e "${GREEN}Enjoy your new cyberpunk subscription page! 🚀${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# Main Installation Process
# ═══════════════════════════════════════════════════════════════

main() {
    print_banner

    log_info "Starting Netwatch template installation..."
    echo ""

    # Pre-flight checks
    check_root
    check_pasarguard
    check_dependencies
    echo ""

    # Installation steps
    create_backup
    create_templates_dir
    download_template
    configure_env
    restart_pasarguard

    # Success
    print_success_message
}

# ═══════════════════════════════════════════════════════════════
# Error Handling
# ═══════════════════════════════════════════════════════════════

trap 'log_error "Installation failed! Check the error messages above."; exit 1' ERR

# ═══════════════════════════════════════════════════════════════
# Execute
# ═══════════════════════════════════════════════════════════════

main "$@"
