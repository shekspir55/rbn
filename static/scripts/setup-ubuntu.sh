#!/bin/bash

# Ubuntu Server Setup Script
# This script installs Fish shell, Docker, htop, and Midnight Commander on Ubuntu systems
# 
# Usage:
#   Run directly: bash setup-ubuntu.sh
#   Run via curl: curl -fsSL https://rbn.am/scripts/setup-ubuntu.sh | bash
#
# Requirements: Ubuntu 18.04+ with sudo privileges

set -e  # Exit on any error

# ASCII Art
echo "🚀 Starting Ubuntu server setup..."
echo "This script will install:"
echo "  - Fish shell (set as default for all users)"
echo "  - Docker & Docker Compose"
echo "  - htop (system monitor)"
echo "  - mc (Midnight Commander file manager)"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root. Please run as a user with sudo privileges."
   exit 1
fi

# Check if Ubuntu
if ! grep -q "ubuntu" /etc/os-release; then
    echo "❌ This script is designed for Ubuntu. Detected OS:"
    cat /etc/os-release | grep PRETTY_NAME
    exit 1
fi

echo "✅ Detected Ubuntu system"

# Ask about firewall configuration early
echo ""
echo "🔥 Firewall Configuration"
echo "Would you like to open ports 80 (HTTP) and 443 (HTTPS) in the firewall?"
echo "This is useful for web servers and SSL certificates."
read -p "Open firewall ports 80 and 443? (y/N): " -n 1 -r
echo ""
CONFIGURE_FIREWALL=$REPLY

# Update package index
echo "📦 Updating package index..."
sudo apt update

# Install essential tools
echo "🛠️ Installing essential tools (htop, mc)..."
sudo apt install -y htop mc

# Install Fish shell
echo "🐠 Installing Fish shell..."
if ! command -v fish &> /dev/null; then
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt update
    sudo apt install -y fish
    echo "✅ Fish shell installed"
else
    echo "⏭️  Fish shell already installed"
fi

# Set Fish as default shell for all users
echo "🔧 Setting Fish as default shell for all users..."
if ! grep -q "/usr/bin/fish" /etc/default/useradd; then
    sudo sed -i 's|/bin/bash|/usr/bin/fish|g' /etc/default/useradd
    echo "✅ Fish set as default for new users"
else
    echo "⏭️  Fish already set as default for new users"
fi

# Set Fish as default shell for current user
if [[ $SHELL != "/usr/bin/fish" ]]; then
    sudo chsh -s /usr/bin/fish $USER
    echo "✅ Fish set as default for current user"
else
    echo "⏭️  Fish already default for current user"
fi

# Create welcome message for Fish shell
echo "🐠 Creating Fish shell welcome message..."
if [ ! -f /etc/fish/conf.d/00-welcome.fish ]; then
    sudo mkdir -p /etc/fish/conf.d
    sudo tee /etc/fish/conf.d/00-welcome.fish > /dev/null << 'EOF'
# Welcome message for Fish shell
function fish_greeting
    echo ""
    echo "    ╔══════════════════════════════════════════╗"
    echo "    ║          Welcome to Fish Shell!          ║"
    echo "    ║                                          ║"
    echo "    ║               ヽ(°〇°)ﾉ                   ║"
    echo "    ║                                          ║"
    echo "    ║   🐠 This server was configured with     ║"
    echo "    ║   the setup script from:                 ║"
    echo "    ║                                          ║"
    echo "    ║   https://rbn.am/scripts/setup-ubuntu.sh ║"
    echo "    ╚══════════════════════════════════════════╝"
    echo ""
end
EOF
    echo "✅ Fish welcome message created"
else
    echo "⏭️  Fish welcome message already exists"
fi

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Remove old Docker versions
    sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Install prerequisites
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    echo "✅ Docker installed"
else
    echo "⏭️  Docker already installed"
fi

# Add current user to docker group
echo "👥 Adding user to docker group..."
if ! groups $USER | grep -q docker; then
    sudo usermod -aG docker $USER
    echo "✅ User added to docker group"
else
    echo "⏭️  User already in docker group"
fi

# Enable and start Docker service
echo "🔄 Enabling Docker service..."
if ! systemctl is-enabled docker &> /dev/null; then
    sudo systemctl enable docker
    echo "✅ Docker service enabled"
else
    echo "⏭️  Docker service already enabled"
fi

if ! systemctl is-active docker &> /dev/null; then
    sudo systemctl start docker
    echo "✅ Docker service started"
else
    echo "⏭️  Docker service already running"
fi

# Configure firewall if requested
if [[ $CONFIGURE_FIREWALL =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚪 Configuring firewall..."
    
    # Check if ufw is available
    if command -v ufw &> /dev/null; then
        echo "Using ufw (Uncomplicated Firewall)..."
        sudo ufw allow 80/tcp
        sudo ufw allow 443/tcp
        
        # Enable ufw if not already enabled
        if ! sudo ufw status | grep -q "Status: active"; then
            echo "Enabling ufw..."
            echo "y" | sudo ufw enable
        fi
        
        echo "✅ Ports 80 and 443 opened with ufw"
    elif command -v iptables &> /dev/null; then
        echo "Using iptables..."
        sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
        sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
        
        # Try to save iptables rules
        if command -v iptables-persistent &> /dev/null; then
            sudo iptables-save > /etc/iptables/rules.v4
        elif command -v netfilter-persistent &> /dev/null; then
            sudo netfilter-persistent save
        else
            echo "⚠️  Note: iptables rules may not persist after reboot"
            echo "   Consider installing iptables-persistent package"
        fi
        
        echo "✅ Ports 80 and 443 opened with iptables"
    else
        echo "⚠️  No supported firewall found (ufw or iptables)"
        echo "   You may need to configure firewall manually"
    fi
else
    echo "⏭️  Firewall configuration skipped"
fi

# Verify installations
echo ""
echo "🔍 Verifying installations..."

# Check installations
if command -v fish &> /dev/null; then
    echo "✅ Fish shell installed: $(fish --version)"
else
    echo "❌ Fish shell installation failed"
fi

if command -v htop &> /dev/null; then
    echo "✅ htop installed"
else
    echo "❌ htop installation failed"
fi

if command -v mc &> /dev/null; then
    echo "✅ Midnight Commander installed"
else
    echo "❌ Midnight Commander installation failed"
fi

if command -v docker &> /dev/null; then
    echo "✅ Docker installed: $(docker --version)"
    echo "✅ Docker Compose installed: $(docker compose version)"
    # Docker includes buildx by default
    if docker buildx version &> /dev/null; then
        echo "✅ Docker Buildx available: $(docker buildx version)"
    fi
else
    echo "❌ Docker installation failed"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Log out and log back in (or run 'newgrp docker') to use Docker without sudo"
echo "  2. Fish is now the default shell for all new users - restart your terminal"
echo "  3. Test Docker: docker run hello-world"
echo "  4. Fish config location: ~/.config/fish/config.fish"
echo ""
echo "💡 Useful commands:"
echo "  - htop: Interactive system monitor"
echo "  - mc: Launch Midnight Commander file manager"
echo "  - fish_config: Open Fish web-based configuration"
echo "  - docker ps: List running containers"
echo "  - docker buildx: Multi-platform builds (included with Docker)"