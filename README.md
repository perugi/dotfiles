# dotfiles
My configuration files

## Fresh Installation

### WSL (Ubuntu)

#### Option 1: Direct Install
Download and run the setup script directly:
```bash
curl -fsSL https://raw.githubusercontent.com/perugi/dotfiles/main/wsl-setup.sh | bash
```

#### Option 2: Clone First (Recommended)
Clone the repository first for more control:
```bash
git clone https://github.com/perugi/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x wsl-setup.sh
./wsl-setup.sh
```

After the script completes, restart your terminal or run:
```bash
exec fish
```

### Fedora

#### Option 1: Direct Install
Download and run the setup script directly:
```bash
curl -fsSL https://raw.githubusercontent.com/perugi/dotfiles/main/fedora-setup.sh | bash
```

#### Option 2: Clone First (Recommended)
Clone the repository first for more control:
```bash
git clone https://github.com/perugi/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x fedora-setup.sh
./fedora-setup.sh
```

After the script completes, restart your terminal or run:
```bash
exec fish
```

## What Gets Installed

Both setup scripts install:
- **Shell**: Fish shell with Starship prompt
- **Terminal**: tmux
- **Editor**: vim with vim-plug
- **Modern CLI Tools**: fzf, zoxide, eza, bat, fd, ripgrep, lazygit
- **Development**: Docker, Node.js (via nvm)

The scripts will:
1. Update system packages
2. Install all required tools
3. Clone this dotfiles repository (if not already present)
4. Backup existing config files
5. Symlink your dotfiles using dotbot
6. Install vim plugins
7. Set Fish as your default shell
