#!/usr/bin/env bash

###############################################################################
# Fedora Fresh Install Setup Script
# 
# This script:
# 1. Updates system packages
# 2. Installs all required programs and tools
# 3. Clones the dotfiles repository
# 4. Runs dotbot to symlink configuration files
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
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

# Configuration
DOTFILES_REPO="https://github.com/perugi/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Detect if we're running from within the dotfiles directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/install.conf.yaml" ] && [ -f "$SCRIPT_DIR/install" ]; then
    RUNNING_FROM_REPO=true
    DOTFILES_DIR="$SCRIPT_DIR"
    log_info "Detected script running from dotfiles repository: $DOTFILES_DIR"
else
    RUNNING_FROM_REPO=false
fi

###############################################################################
# 1. System Update
###############################################################################
log_info "Updating system packages..."
sudo dnf update -y
log_success "System updated"

###############################################################################
# 2. Install Essential Packages
###############################################################################
log_info "Installing essential packages..."
sudo dnf install -y \
    git \
    curl \
    wget \
    @development-tools \
    python3 \
    python3-pip

log_success "Essential packages installed"

###############################################################################
# 3. Install Shell and Terminal Tools
###############################################################################
log_info "Installing Fish shell..."
sudo dnf install -y fish
log_success "Fish shell installed"

log_info "Installing tmux..."
sudo dnf install -y tmux
log_success "Tmux installed"

log_info "Installing vim..."
sudo dnf install -y vim
log_success "Vim installed"

log_info "Installing vim-plug (plugin manager)..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
log_success "vim-plug installed"

###############################################################################
# 4. Install Modern CLI Tools
###############################################################################
log_info "Installing fzf (fuzzy finder)..."
sudo dnf install -y fzf
log_success "fzf installed"

log_info "Installing zoxide (smart cd)..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
log_success "zoxide installed"

log_info "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
log_success "Starship installed"

log_info "Installing xclip (clipboard support)..."
sudo dnf install -y xclip
log_success "xclip installed"

log_info "Installing eza (modern ls replacement)..."
if ! command -v eza &> /dev/null; then
    sudo dnf install -y eza
    log_success "eza installed"
else
    log_warning "eza already installed, skipping"
fi

log_info "Installing bat (modern cat replacement)..."
sudo dnf install -y bat
log_success "bat installed"

log_info "Installing fd (modern find replacement)..."
sudo dnf install -y fd-find
log_success "fd installed"

log_info "Installing ripgrep (modern grep replacement)..."
sudo dnf install -y ripgrep
log_success "ripgrep installed"

log_info "Installing lazygit (Git TUI)..."
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y lazygit
log_success "lazygit installed"

###############################################################################
# 5. Install Docker
###############################################################################
log_info "Installing Docker..."
# Remove any old docker packages
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine 2>/dev/null || true

# Add Docker repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group (to run docker without sudo)
sudo usermod -aG docker $USER

log_success "Docker installed (you may need to log out and back in for group membership to take effect)"

###############################################################################
# 6. Install Optional Development Tools
###############################################################################
log_info "Installing Node.js via nvm..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    log_success "Node.js installed via nvm"
else
    log_warning "nvm already installed, skipping"
fi

###############################################################################
# 7. Clone Dotfiles Repository
###############################################################################
if [ "$RUNNING_FROM_REPO" = true ]; then
    log_info "Skipping clone - already running from dotfiles repository"
else
    if [ -d "$DOTFILES_DIR" ]; then
        log_warning "Dotfiles directory already exists at $DOTFILES_DIR"
        read -p "Do you want to remove it and clone fresh? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$DOTFILES_DIR"
            log_info "Removed existing dotfiles directory"
        else
            log_error "Aborting: Dotfiles directory already exists"
            exit 1
        fi
    fi

    log_info "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    log_success "Dotfiles repository cloned to $DOTFILES_DIR"
fi

###############################################################################
# 8. Backup and Remove Existing Config Files
###############################################################################
log_info "Backing up and removing existing config files..."

# List of files that might conflict with dotbot
BACKUP_FILES=(
    "$HOME/.bashrc"
    "$HOME/.bash_logout"
    "$HOME/.inputrc"
    "$HOME/.tmux.conf"
    "$HOME/.vimrc"
)

BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$file" ] || [ -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        log_info "Backing up $file to $BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
    fi
done

if [ -d "$BACKUP_DIR" ]; then
    log_success "Original config files backed up to $BACKUP_DIR"
fi

###############################################################################
# 9. Run Dotbot to Install Dotfiles
###############################################################################
log_info "Running dotbot to symlink configuration files..."
cd "$DOTFILES_DIR"
./install
log_success "Dotfiles installed successfully!"

###############################################################################
# 10. Install Vim Plugins
###############################################################################
log_info "Installing Vim plugins..."
# Run PlugInstall silently, continue even if there are errors
vim +'PlugInstall --sync' +qa 2>/dev/null || true
log_success "Vim plugins installed"

###############################################################################
# 11. Set Fish as Default Shell
###############################################################################
log_info "Setting Fish as the default shell..."
if [ "$SHELL" != "$(which fish)" ]; then
    chsh -s "$(which fish)"
    log_success "Fish set as default shell (restart terminal to take effect)"
else
    log_warning "Fish is already the default shell"
fi

###############################################################################
# 12. Final Steps
###############################################################################
echo
log_success "============================================"
log_success "Fedora Setup Complete!"
log_success "============================================"
echo
log_info "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Verify installations by checking versions:"
echo "     - fish --version"
echo "     - tmux -V"
echo "     - starship --version"
echo "     - fzf --version"
echo "     - zoxide --version"
echo "     - docker --version"
echo "  3. Your dotfiles are symlinked from: $DOTFILES_DIR"
echo
log_info "Enjoy your configured Fedora environment! 🚀"
