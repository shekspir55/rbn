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

# Update package index
echo "📦 Updating package index..."
sudo apt update

# Install essential tools
echo "🛠️ Installing essential tools (htop, mc)..."
sudo apt install -y htop mc

# Install Fish shell
echo "🐠 Installing Fish shell..."
sudo apt install -y software-properties-common
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish

# Set Fish as default shell for all users
echo "🔧 Setting Fish as default shell for all users..."
sudo sed -i 's|/bin/bash|/usr/bin/fish|g' /etc/default/useradd
sudo chsh -s /usr/bin/fish $USER

# Install Docker
echo "🐳 Installing Docker..."

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

# Add current user to docker group
echo "👥 Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable and start Docker service
echo "🔄 Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

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