#!/bin/bash

# Get the directory where the script is being run from
SCRIPT_DIR="$(pwd)"

# Log file for installation output
LOGFILE="$SCRIPT_DIR/install.log"

# Force flag - set to true to reinstall even if already installed
FORCE=false

# Function to log section headers with spacing
logSection() {
	echo ""
	echo ""
	echo "$1"
}

# Function to display usage information
usage() {
	cat <<EOF
Usage: $0 [OPTIONS] [COMPONENTS]

Install development tools and applications.

OPTIONS:
    --force, -f         Force reinstallation even if already installed

COMPONENTS:
    all                 Install everything (default if no argument provided)
    aliases             Set up bash aliases
    apt                 Install apt packages
    chrome              Install Google Chrome
    neovim              Install Neovim
    firacode            Install FiraCode Nerd Font
    starship            Install Starship prompt
    fzf                 Install fzf (command line fuzzy finder)
    eza                 Install eza (modern ls replacement)
    zoxide              Install zoxide (smart cd replacement)
    ghostty             Install Ghostty terminal emulator
    dotfiles            Clone and stow dotfiles
    opencode            Install OpenCode.ai CLI tool
    volta               Install Volta (Node.js version manager)
    node                Install Node.js via Volta
    pnpm                Install pnpm package manager
    docker              Install Docker
    cleanup             Remove unnecessary apt packages
    help                Display this help message

EXAMPLES:
    $0                      # Install everything
    $0 all                  # Install everything
    $0 chrome neovim        # Install only Chrome and Neovim
    $0 --force chrome       # Reinstall Chrome even if already installed
    $0 -f all               # Force reinstall everything
    $0 help                 # Show this help

EOF
}

# Initialize log file
init_log() {
	echo "Installation started at $(date)" >"$LOGFILE"
}

# Set up bash aliases
install_aliases() {
	cd ~/ || exit
	echo "Updating aliases..."

	# create .bash_aliases file if it does not exist
	if [ ! -f ~/.bash_aliases ]; then
		touch ~/.bash_aliases
	fi

	# create aliases if they do not already exist
	declare -A aliases
	aliases=(
		[".."]="cd .."
		["..."]="cd ../.."
		["...."]="cd ../../../"
		["cd"]="zd"
		["cpssh"]="rsync -avzP --progress -e ssh"
		["catx"]="batcat -pp"
		["cat"]="batcat"
		["cp"]="rsync -ah --info=progress2 --inplace --partial"
		["l"]="eza -h --group-directories-first --icons=auto"
		["la"]="eza -ah --group-directories-first --icons=auto"
		["ls"]="eza -lh --group-directories-first --icons=auto --git"
		["lsa"]="ls -a"
		["lt"]="eza --tree --level=2 --long --icons --git"
		["lta"]="lt -a"
		["vi"]="nvim"
		["vim"]="nvim"
	)
	for alias in "${!aliases[@]}"; do
		if ! grep -q "alias $alias=" ~/.bash_aliases; then
			echo "alias $alias='${aliases[$alias]}'" >>~/.bash_aliases
		fi
	done
	echo "Finished updating aliases."
}

# Install apt packages
install_apt() {
	cd ~/ || exit
	logSection "Installing apt packages..."
	sudo apt update >>"$LOGFILE" 2>&1 && sudo apt install -y git curl wget stow build-essential kitty ripgrep bat btop ca-certificates gnupg >>"$LOGFILE" 2>&1
	echo "All apt packages installed successfully."
}

# Install Google Chrome
install_chrome() {
	cd ~/ || exit
	logSection "Installing Google Chrome..."
	if command -v google-chrome >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "Google Chrome is already installed."
	else
		curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >>"$LOGFILE" 2>&1
		sudo dpkg -i google-chrome-stable_current_amd64.deb >>"$LOGFILE" 2>&1
		rm google-chrome-stable_current_amd64.deb
		echo "Google Chrome installed successfully."
	fi
}

# Install Neovim
install_neovim() {
	cd ~/ || exit
	logSection "Installing Neovim..."
	if [ -x "$(command -v nvim)" ] && [ "$FORCE" = false ]; then
		echo "Neovim is already installed."
	else
		# Remove existing symlink if it exists
		if [ -e /usr/bin/nvim ]; then
			sudo rm /usr/bin/nvim >>"$LOGFILE" 2>&1
		fi

		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >>"$LOGFILE" 2>&1
		sudo rm -rf /opt/nvim-linux-x86_64 >>"$LOGFILE" 2>&1
		sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz >>"$LOGFILE" 2>&1
		sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/bin/nvim >>"$LOGFILE" 2>&1
		rm nvim-linux-x86_64.tar.gz
		echo "Neovim installed successfully."
	fi
}

# Install FiraCode Nerd Font
install_firacode() {
	cd ~/ || exit
	logSection "Installing FiraCode Nerd Font..."
	if ls ~/.fonts/FiraCode* 1>/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "FiraCode Nerd Font is already installed."
	else
		# Remove existing FiraCode files if they exist
		if ls ~/.fonts/FiraCode* 1>/dev/null 2>&1; then
			rm ~/.fonts/FiraCode* >>"$LOGFILE" 2>&1
		fi
		if [ -f ~/.fonts/README.md ]; then
			rm ~/.fonts/README.md >>"$LOGFILE" 2>&1
		fi
		if [ -f ~/.fonts/LICENSE ]; then
			rm ~/.fonts/LICENSE >>"$LOGFILE" 2>&1
		fi

		curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip >>"$LOGFILE" 2>&1
		mkdir -p ~/.fonts
		unzip FiraCode.zip -d ~/.fonts >>"$LOGFILE" 2>&1
		rm FiraCode.zip
		fc-cache -fv >>"$LOGFILE" 2>&1
		echo "FiraCode Nerd Font installed successfully."
	fi
}

# Install Starship prompt
install_starship() {
	cd ~/ || exit
	logSection "Installing Starship prompt..."
	if command -v starship >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "Starship is already installed."
	else
		curl -sS https://starship.rs/install.sh | sh -s -- --yes >>"$LOGFILE" 2>&1
		echo "Starship installed successfully."
	fi
	if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
		echo 'eval "$(starship init bash)"' >>~/.bashrc
	fi
}

# Install fzf
install_fzf() {
	cd ~/ || exit
	logSection "Installing fzf (command line fuzzy finder)..."
	if [ -d ~/.fzf ] && [ "$FORCE" = false ]; then
		echo "fzf already installed."
	else
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >>"$LOGFILE" 2>&1
		~/.fzf/install --all --no-zsh --no-fish >>"$LOGFILE" 2>&1
		echo "fzf installed successfully."
	fi
}

# Install eza
install_eza() {
	cd ~/ || exit
	logSection "Installing eza (modern ls replacement)..."
	if command -v eza --version >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "eza is already installed."
	else
		sudo mkdir -p /etc/apt/keyrings
		wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
		echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
		sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
		sudo apt update >>"$LOGFILE" 2>&1 && sudo apt install -y eza >>"$LOGFILE" 2>&1
		echo "eza installed successfully."
	fi
}

# Install Zoxide
install_zoxide() {
	cd ~/ || exit
	logSection "Installing zoxide (smart cd replacement)..."
	if command -v zoxide --version >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "zoxide is already installed."
	else
		curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >>"$LOGFILE" 2>&1
		echo "zoxide installed successfully."
	fi
	if ! grep -q '/.local/bin' ~/.bashrc; then
		echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.bashrc
	fi
	if ! grep -q 'eval "$(zoxide init bash' ~/.bashrc; then
		echo 'eval "$(zoxide init bash --cmd cd)"' >>~/.bashrc
	fi
}

# Install Ghostty terminal emulator
install_ghostty() {
	cd ~/ || exit
	logSection "Installing Ghostty terminal emulator..."
	if command -v ghostty >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "Ghostty is already installed."
	else
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)" >>"$LOGFILE" 2>&1
		echo "Ghostty installed successfully."
	fi
}

# Clone and stow dotfiles
install_dotfiles() {
	cd ~/ || exit
	logSection "Setting up dotfiles..."
	
	# Check if ghostty config exists and backup if needed
	GHOSTTY_BACKUP=false
	if [ -f ~/.config/ghostty/config ]; then
		echo "Backing up existing ghostty config..."
		mv ~/.config/ghostty/config ~/.config/ghostty/config_orig
		GHOSTTY_BACKUP=true
	fi
	
	if [ -d ~/dotfiles ] && [ "$FORCE" = false ]; then
		echo "Dotfiles directory already exists. Skipping git clone."
	else
		if [ -d ~/dotfiles ]; then
			echo "Removing existing dotfiles directory..."
			rm -rf ~/dotfiles
		fi
		echo "Cloning dotfiles repository..."
		git clone https://github.com/walts81/dotfiles ~/dotfiles >>"$LOGFILE" 2>&1
		echo "Dotfiles repo cloned successfully."
	fi
	cd ~/dotfiles || exit
	stow -S bat btop git kitty neovim starship backgrounds ghostty >>"$LOGFILE" 2>&1
	
	# Add config-file line to new ghostty config if we backed up original
	if [ "$GHOSTTY_BACKUP" = true ]; then
		echo "Adding reference to original ghostty config..."
		# Create temp file with new content
		{
			echo "config-file = ?~/.config/ghostty/config_orig"
			echo ""
			cat ~/.config/ghostty/config
		} > ~/.config/ghostty/config.tmp
		mv ~/.config/ghostty/config.tmp ~/.config/ghostty/config
	fi
	
	gsettings set org.gnome.desktop.background picture-uri-light "file:///$HOME/.local/share/backgrounds/bttf.jpg"
	gsettings set org.gnome.desktop.background picture-uri-dark "file:///$HOME/.local/share/backgrounds/bttf.jpg"
	cd ~/ || exit
}

# Install OpenCode.ai CLI tool
install_opencode() {
	cd ~/ || exit
	logSection "Installing OpenCode.ai cli tool..."
	if command -v opencode >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "OpenCode is already installed."
	else
		curl -fsSL https://opencode.ai/install | bash >>"$LOGFILE" 2>&1
		echo "OpenCode.ai cli tool installed successfully."
	fi
}

# Install Volta (Node.js version manager)
install_volta() {
	cd ~/ || exit
	logSection "Installing Volta (NodeJS version manager)..."
	if command -v volta >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "Volta is already installed."
	else
		curl https://get.volta.sh | bash >>"$LOGFILE" 2>&1
		echo "Volta installed successfully."
	fi

	# Source Volta's environment to make it available in current session
	export VOLTA_HOME="$HOME/.volta"
	export PATH="$VOLTA_HOME/bin:$PATH"
}

# Install Node.js via Volta
install_node() {
	cd ~/ || exit
	# Ensure Volta is in PATH
	export VOLTA_HOME="$HOME/.volta"
	export PATH="$VOLTA_HOME/bin:$PATH"

	logSection "Installing NodeJS..."
	if node --version >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "NodeJS is already installed."
	else
		volta install node >>"$LOGFILE" 2>&1
		echo "NodeJS installed successfully."
	fi
}

# Install pnpm package manager
install_pnpm() {
	cd ~/ || exit
	logSection "Installing PNPM (supercharged Node package manager)..."
	if pnpm --version >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "pnpm is already installed."
	else
		curl -fsSL https://get.pnpm.io/install.sh | sh - >>"$LOGFILE" 2>&1
		echo "pnpm installed successfully."
	fi

	# Source pnpm environment if it exists
	if [ -f "$HOME/.bashrc" ]; then
		export PNPM_HOME="$HOME/.local/share/pnpm"
		export PATH="$PNPM_HOME:$PATH"
	fi
}

# Install Docker
install_docker() {
	cd ~/ || exit
	logSection "Installing Docker..."
	. /etc/os-release
	arch="$(dpkg --print-architecture)"
	codename="${VERSION_CODENAME:-$UBUNTU_CODENAME}"
	if command -v docker >/dev/null 2>&1 && [ "$FORCE" = false ]; then
		echo "Docker is already installed."
	else
		sudo apt remove -y docker.io docker-doc docker-compose podman-docker containerd runc >>"$LOGFILE" 2>&1 || true

		# Add Docker's official GPG key
		sudo install -d -m 0755 /etc/apt/keyrings >>"$LOGFILE" 2>&1
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
			sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >>"$LOGFILE" 2>&1
		sudo chmod a+r /etc/apt/keyrings/docker.gpg >>"$LOGFILE" 2>&1

		# Set up the Docker repository
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null <<EOF
    deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${codename} stable
EOF

		# Install docker packages from apt
		sudo apt update >>"$LOGFILE" 2>&1
		sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >>"$LOGFILE" 2>&1
		sudo systemctl enable docker >>"$LOGFILE" 2>&1
		sudo systemctl start docker >>"$LOGFILE" 2>&1

		sudo groupadd -f docker >>"$LOGFILE" 2>&1
		sudo usermod -aG docker $USER >>"$LOGFILE" 2>&1
		echo "Added $USER to docker group. Log out/in for group change to apply."

		# Optional recommended daemon defaults: log rotation
		sudo install -d -m 0755 /etc/docker >>"$LOGFILE" 2>&1
		sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
    {
        "log-driver": "json-file",
        "log-opts": {
            "max-size": "10m",
            "max-file": "3"
        }
    }
EOF

		sudo systemctl restart docker >>"$LOGFILE" 2>&1
		echo "Docker installed successfully."
	fi
}

# Clean up unnecessary packages
install_cleanup() {
	cd ~/ || exit
	logSection "Cleanup unused apt packages..."
	sudo apt autoremove -y >>"$LOGFILE" 2>&1
	echo "Cleanup completed."
}

# Install all components
install_all() {
	install_aliases
	install_apt
	install_chrome
	install_neovim
	install_firacode
	install_starship
	install_eza
	install_fzf
	install_zoxide
	install_ghostty
	install_dotfiles
	install_opencode
	install_volta
	install_node
	install_pnpm
	install_docker
	install_cleanup
}

# Main script logic
main() {
	# Initialize log file
	init_log

	# If no arguments provided, install everything
	if [ $# -eq 0 ]; then
		install_all
		exit 0
	fi

	# Parse arguments - first check for force flag
	for arg in "$@"; do
		case "$arg" in
		--force | -f)
			FORCE=true
			;;
		esac
	done

	# Parse arguments for components to install
	for arg in "$@"; do
		case "$arg" in
		--force | -f)
			# Already handled above, skip
			;;
		all)
			install_all
			;;
		aliases)
			install_aliases
			;;
		apt)
			install_apt
			;;
		chrome)
			install_chrome
			;;
		neovim)
			install_neovim
			;;
		firacode)
			install_firacode
			;;
		starship)
			install_starship
			;;
		eza)
			install_eza
			;;
		fzf)
			install_fzf
			;;
		zoxide)
			install_zoxide
			;;
		ghostty)
			install_ghostty
			;;
		dotfiles)
			install_dotfiles
			;;
		opencode)
			install_opencode
			;;
		volta)
			install_volta
			;;
		node)
			install_node
			;;
		pnpm)
			install_pnpm
			;;
		docker)
			install_docker
			;;
		cleanup)
			install_cleanup
			;;
		help | --help | -h)
			usage
			exit 0
			;;
		*)
			echo "Error: Unknown option '$arg'"
			echo ""
			usage
			exit 1
			;;
		esac
	done
}

# Run main function with all arguments
main "$@"
