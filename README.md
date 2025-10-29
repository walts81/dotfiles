# Dotfiles

Personal configuration files managed with GNU Stow.

## Quick Start

### Omarchy/Hyprland Setup (Current)

For the modern Wayland-based setup with Omarchy:

```bash
cd ~/dotfiles
./setup-omarchy.sh
```

The setup script will:
- Automatically backup existing configs to `~/.config-backup-YYYYMMDD-HHMMSS/`
- Stow all dotfiles as symlinks to `~/.config/`
- Create `monitors.conf` from template (machine-specific)

**To restore from backup:**
```bash
cd ~/dotfiles
./restore-backup.sh  # Uses most recent backup
# or specify a backup directory
./restore-backup.sh ~/.config-backup-20241028-143000
```

### Legacy Setup (i3/X11)

For the older i3-based X11 setup:

```bash
cd ~/dotfiles
./setup.sh
```

## Structure

Each directory represents a "package" that can be independently managed with stow:

- `hypr/` - Hyprland window manager configuration
- `waybar/` - Wayland status bar
- `mako/` - Notification daemon
- `walker/` - Application launcher
- `omarchy/` - Omarchy theme selection and preferences
- `neovim-omarchy/` - LazyVim-based neovim config from Omarchy
- `neovim/` - Original neovim configuration
- `git/` - Git configuration and aliases
- `starship/` - Cross-shell prompt
- Terminal emulators: `ghostty/`, `kitty/`, `alacritty/`
- CLI tools: `bat/`, `btop/`, `fastfetch/`
- Legacy configs: `i3/`, `polybar/`, `awesome/`, `picom/`

## Machine-Specific Configuration

Some files are machine-specific and excluded from git:

- `~/.config/hypr/monitors.conf` - Monitor configuration
  - Template available as `monitors.conf.template`
  - Copy and customize for each machine

- `~/.config/git/config.local` - Personal git credentials
  - Contains your git username and email
  - Created automatically by `setup-omarchy.sh` if it doesn't exist
  - Manual creation:
    ```bash
    cat > ~/.config/git/config.local << 'EOF'
    [user]
      name = Your Name
      email = your.email@example.com
    EOF
    ```

## Syncing Between Machines

1. **Desktop**: Make changes and commit
   ```bash
   cd ~/dotfiles
   git add -A
   git commit -m "Update configs"
   git push
   ```

2. **Laptop**: Pull changes and re-stow
   ```bash
   cd ~/dotfiles
   git pull
   ./setup-omarchy.sh
   ```

3. **Machine-specific files**: Keep your local `monitors.conf` and don't commit it

## Manual Stow Usage

Stow individual packages:
```bash
stow -S hypr waybar  # Install
stow -D hypr         # Remove
stow -R hypr         # Reinstall (remove + install)
```

## Security Note

This is a public repository. Sensitive files are excluded via `.gitignore`:
- Browser sessions and cache
- Application credentials (Bitwarden, etc.)
- Personal data (recent files, history)
- Machine-specific system settings

Always review before committing new configurations.
