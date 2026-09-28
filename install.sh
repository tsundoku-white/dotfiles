#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Installing native Arch packages..."
sudo pacman -S --needed - < "$DOTFILES_DIR/pkglist-repo.txt"

# Ensure git and base-devel are installed to build yay
sudo pacman -S --needed --noconfirm git base-devel

echo "==> Checking for yay..."
if ! command -v yay &> /dev/null; then
    echo "==> Installing yay..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    (cd /tmp/yay-bin && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bin
fi

echo "==> Installing AUR packages..."
yay -S --needed - < "$DOTFILES_DIR/pkglist-aur.txt"

if command -v flatpak &> /dev/null && [ -f "$DOTFILES_DIR/pkglist-flatpak.txt" ]; then
    echo "==> Installing Flatpaks..."
    xargs flatpak install -y flathub < "$DOTFILES_DIR/pkglist-flatpak.txt"
fi

echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow -R app-configs
stow -R Pictures

echo "==> Deploying SDDM configuration..."
sudo cp -r "$DOTFILES_DIR/sddm/"* /usr/share/sddm/

echo "==> Deploying GRUB configuration..."
sudo cp -r "$DOTFILES_DIR/grub/"* /etc/default/

echo "==> Setup complete!"
