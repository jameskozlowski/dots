#!/bin/bash

# Install yay if not already installed
if ! command -v yay &>/dev/null; then
	echo "yay could not be found, installing..."
	sudo pacman -S --noconfirm git base-devel

	# Clone the yay repository
	git clone https://aur.archlinux.org/yay-bin
	cd yay-bin
	makepkg -si --noconfirm

	# Clean up
	cd ..
	rm -rf yay-bin
fi
yay -Syu --noconfirm

# Change to the directory of this script
cd "$(dirname "$0")"

declare -A mappings=(
	["$HOME/git/dots/nvim"]=$HOME/.config/nvim
	["$HOME/git/dots/.gitconfig"]=$HOME/.gitconfig
	["$HOME/git/dots/alacritty"]=$HOME/.config/alacritty
	["$HOME/git/dots/.bashrc"]=$HOME/.bashrc
	["$HOME/git/dots/.bash_profile"]=$HOME/.bash_profile
	["$HOME/git/dots/lazygit/"]=$HOME/.config/lazygit
)

echo "Removing existing files/directories..."
for key in "${!mappings[@]}"; do
	rm -rf ${mappings[$key]}
done

echo "Creating symbolic links..."
for key in "${!mappings[@]}"; do
	ln -sf $key ${mappings[$key]}
done

echo "Installing Dependencies..."
yay -S --needed --noconfirm alacritty python fzf ripgrep bat bash-completion screen go lazygit eza zoxide starship ttf-jetbrains-mono-nerd nodejs npm powershell-bin azure-cli-bin bicep-bin github-cli unzip fastfetch wget bat fuse3 fuse2 fuse2fs

echo "Install Neovim Nightly"
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /tmp/nvim
chmod +x /tmp/nvim
sudo mv /tmp/nvim /usr/local/bin/nvim

echo "Done!"
