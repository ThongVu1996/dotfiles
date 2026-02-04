#!/bin/bash

# Sketchybar Installation Script
# For macOS with Nix package manager and Home Manager

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only!"
    exit 1
fi

print_step "Starting Sketchybar setup..."

# 1. Check for Nix
print_step "Checking for Nix package manager..."
if ! command -v nix &> /dev/null; then
    print_error "Nix not found! Please install Nix first:"
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
else
    print_success "Nix found"
fi

# 2. Check for Home Manager
print_step "Checking for Home Manager..."
if ! command -v home-manager &> /dev/null; then
    print_warning "Home Manager not found. Packages should be installed via your Nix configuration."
    print_warning "Please run: nix build or home-manager switch"
else
    print_success "Home Manager found"
fi

# 3. Check if Sketchybar is installed (via Nix)
print_step "Checking for Sketchybar..."
if ! command -v sketchybar &> /dev/null; then
    print_warning "Sketchybar not found in PATH"
    print_warning "Make sure it's defined in your home.nix or flake.nix"
    print_warning "Then run: home-manager switch"
else
    print_success "Sketchybar found: $(which sketchybar)"
fi

# 4. Check for Aerospace
print_step "Checking for Aerospace..."
if ! command -v aerospace &> /dev/null; then
    print_warning "Aerospace not found in PATH"
    print_warning "Add to your Nix configuration or install manually:"
    print_warning "  https://github.com/nikitabobko/AeroSpace"
else
    print_success "Aerospace found: $(which aerospace)"
fi

# 5. Install sketchybar-app-font
print_step "Installing sketchybar-app-font..."
FONT_PATH="$HOME/Library/Fonts/sketchybar-app-font.ttf"
if [ ! -f "$FONT_PATH" ]; then
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o "$FONT_PATH"
    print_success "Font installed to $FONT_PATH"
else
    print_success "Font already installed"
fi

# 6. Verify config directory
print_step "Verifying configuration..."
CONFIG_DIR="$HOME/.config/sketchybar"
if [ ! -d "$CONFIG_DIR" ]; then
    print_warning "Config directory not found at $CONFIG_DIR"
    print_warning "Make sure your dotfiles are linked via Home Manager"
    print_warning "Check your home.nix for: home.file.\".config/sketchybar\""
else
    print_success "Config directory found"
fi

# 7. Make scripts executable
print_step "Setting executable permissions..."
if [ -d "$CONFIG_DIR" ]; then
    chmod +x "$CONFIG_DIR/sketchybarrc" 2>/dev/null || true
    chmod +x "$CONFIG_DIR"/plugins/*.sh 2>/dev/null || true
    chmod +x "$CONFIG_DIR"/items/*.sh 2>/dev/null || true
    print_success "Permissions set"
fi

# 8. Stop any running instance
print_step "Stopping existing Sketchybar instances..."
killall sketchybar 2>/dev/null || true
print_success "Stopped existing instances"

# 9. Start Sketchybar
print_step "Starting Sketchybar..."
sketchybar &
print_success "Sketchybar started in background"

# 10. Print post-installation instructions
echo ""
print_success "Setup complete!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "1. ${YELLOW}Grant Accessibility permissions:${NC}"
echo "   → System Settings → Privacy & Security → Accessibility"
echo "   → Add and enable:"
echo "     • $(which sketchybar)"
echo "     • /usr/bin/osascript"
echo ""
echo "2. ${YELLOW}Configure Aerospace workspaces${NC} in ~/.aerospace.toml:"
echo "   [workspace-to-monitor-force-assignment]"
echo "   A = 1"
echo "   B = 1"
echo "   C = 1"
echo "   D = 1"
echo ""
echo "3. ${YELLOW}Reload Sketchybar:${NC}"
echo "   sketchybar --reload"
echo ""
echo "4. ${YELLOW}Check status:${NC}"
echo "   pgrep -l sketchybar"
echo ""
echo -e "${BLUE}Troubleshooting:${NC}"
echo "   → View logs: tail -f /tmp/sketchybar_*.log"
echo "   → Restart: killall sketchybar && sketchybar &"
echo "   → Reload config: sketchybar --reload"
echo "   → Update Nix packages: home-manager switch"
echo ""
echo -e "${BLUE}Nix Configuration:${NC}"
echo "   Make sure your home.nix includes:"
echo "   • home.packages = [ pkgs.sketchybar pkgs.aerospace ... ];"
echo "   • home.file.\".config/sketchybar\".source = ./dotfiles/sketchybar/.config/sketchybar;"
echo ""
print_success "Enjoy your new status bar! 🚀"
