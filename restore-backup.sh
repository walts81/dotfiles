#!/bin/bash

# Restore script to undo setup-omarchy.sh changes
# This will unstow dotfiles and restore from backup

set -e

# Find the most recent backup directory
if [ -n "$1" ]; then
    BACKUP_DIR="$1"
else
    BACKUP_DIR=$(ls -dt ~/.config-backup-* 2>/dev/null | head -1)
fi

if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: No backup directory found."
    echo "Usage: $0 [backup-directory]"
    echo ""
    echo "Available backups:"
    ls -dt ~/.config-backup-* 2>/dev/null || echo "  None found"
    exit 1
fi

echo "Restoring from: $BACKUP_DIR"
echo ""

# Stow packages to unstow
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

read -p "This will remove stowed symlinks and restore backup. Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Unstowing packages..."
cd ~/dotfiles
stow -D "${PACKAGES[@]}" 2>/dev/null || true
echo ""

echo "Restoring files from backup..."
for item in "$BACKUP_DIR"/*; do
    if [ -e "$item" ]; then
        basename_item=$(basename "$item")
        echo "  Restoring ~/.config/$basename_item"
        # Remove any leftover symlinks or empty dirs
        rm -rf ~/.config/"$basename_item"
        # Restore from backup
        cp -r "$item" ~/.config/
    fi
done

echo ""
echo "Restore complete!"
echo ""
echo "The backup directory is still at: $BACKUP_DIR"
echo "You can safely delete it once you've verified everything works."
