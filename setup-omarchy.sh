#!/bin/bash

# Setup script for Omarchy/Hyprland dotfiles
# This sets up modern Wayland-based configurations

set -e

echo "Setting up Omarchy dotfiles..."
echo ""

# Stow packages for Omarchy setup
PACKAGES=(
    "hypr"
    "waybar"
    "mako"
    "walker"
    "swayosd"
    "omarchy"
    "neovim-omarchy"
    "git"
    "starship"
    "ghostty"
    "bat"
    "btop"
    "fastfetch"
    "terminal-configs"
    "backgrounds"
    "zsh"
)

# Optional packages (comment out if you don't want them)
# PACKAGES+=("alacritty" "kitty" "rofi")

# Config directories that will be stowed
CONFIG_DIRS=(
    "hypr"
    "waybar"
    "mako"
    "walker"
    "swayosd"
    "omarchy"
    "nvim"
    "git"
    "starship.toml"
    "ghostty"
    "bat"
    "btop"
    "fastfetch"
    "brave-flags.conf"
    "chromium-flags.conf"
)

# Backup existing configs if they exist
BACKUP_DIR=~/.config-backup-$(date +%Y%m%d-%H%M%S)
NEEDS_BACKUP=false

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -e ~/.config/"$dir" ] && [ ! -L ~/.config/"$dir" ]; then
        NEEDS_BACKUP=true
        break
    fi
done

if [ "$NEEDS_BACKUP" = true ]; then
    echo "Backing up existing configs to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ -e ~/.config/"$dir" ] && [ ! -L ~/.config/"$dir" ]; then
            echo "  Backing up ~/.config/$dir"
            mv ~/.config/"$dir" "$BACKUP_DIR/"
        fi
    done
    echo ""
fi

echo "Stowing packages: ${PACKAGES[*]}"
stow -S "${PACKAGES[@]}"
echo ""

# Handle machine-specific configs
if [ ! -f ~/.config/hypr/monitors.conf ]; then
    echo "Creating monitors.conf from template..."
    echo "Please edit ~/.config/hypr/monitors.conf for your specific monitor setup"
    cp ~/.config/hypr/monitors.conf.template ~/.config/hypr/monitors.conf
else
    echo "monitors.conf already exists, skipping..."
fi

# Handle git config.local
if [ ! -f ~/.config/git/config.local ]; then
    echo ""
    echo "Git config.local not found. Let's set up your git credentials."
    read -p "Enter your git username: " git_name
    read -p "Enter your git email: " git_email

    cat > ~/.config/git/config.local << EOF
[user]
  name = $git_name
  email = $git_email
EOF
    echo "Created ~/.config/git/config.local with your credentials"
else
    echo "git config.local already exists, skipping..."
fi

if [ ! -f ~/.config/hypr/envs.conf ]; then
    echo "Creating envs.conf..."
    touch ~/.config/hypr/envs.conf
else
    echo "envs.conf already exists, skipping..."
fi

echo ""
echo "Setup complete!"
echo ""
if [ "$NEEDS_BACKUP" = true ]; then
    echo "Original configs backed up to: $BACKUP_DIR"
    echo ""
fi
echo "Note: If monitors.conf.template has been updated, you may want to"
echo "      review and merge changes into your local monitors.conf"
