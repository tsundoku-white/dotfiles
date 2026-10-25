#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Installing native Arch packages..."
sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist-repo.txt"

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
if [ -s "$DOTFILES_DIR/pkglist-aur.txt" ]; then
    yay -S --needed --noconfirm --answerdiff None --answerclean None --removemake - < "$DOTFILES_DIR/pkglist-aur.txt"
else
    echo "    pkglist-aur.txt is empty, skipping"
fi

if command -v flatpak &> /dev/null && [ -s "$DOTFILES_DIR/pkglist-flatpak.txt" ]; then
    echo "==> Installing Flatpaks..."
    xargs flatpak install -y flathub < "$DOTFILES_DIR/pkglist-flatpak.txt"
fi

echo "==> Enabling services..."
if [ -s "$DOTFILES_DIR/services-system.txt" ]; then
    while read -r unit; do
        [ -n "$unit" ] || continue
        sudo systemctl enable "$unit" || echo "    skip: $unit"
    done < "$DOTFILES_DIR/services-system.txt"
fi

if [ -s "$DOTFILES_DIR/services-user.txt" ]; then
    while read -r unit; do
        [ -n "$unit" ] || continue
        systemctl --user enable "$unit" || echo "    skip (user): $unit"
    done < "$DOTFILES_DIR/services-user.txt"
fi

echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow -R app-configs
stow -R Pictures

echo "==> Rebuilding font cache..."
fc-cache -f

echo "==> Applying GTK/gsettings..."
if [ -f "$DOTFILES_DIR/gsettings-interface.ini" ]; then
    # Needs a running session bus; harmless to skip and re-run from the desktop
    if ! dconf load /org/gnome/desktop/interface/ < "$DOTFILES_DIR/gsettings-interface.ini"; then
        echo "    dconf load failed (no session bus?). Re-run it after logging in:"
        echo "    dconf load /org/gnome/desktop/interface/ < $DOTFILES_DIR/gsettings-interface.ini"
    fi
fi

echo "==> Deploying SDDM configuration..."
sudo mkdir -p /usr/share/sddm/themes /etc/sddm.conf.d
sudo cp -r "$DOTFILES_DIR/sddm/themes/"* /usr/share/sddm/themes/
sudo cp "$DOTFILES_DIR/sddm/sddm.conf.d/theme.conf" /etc/sddm.conf.d/

echo "==> Deploying GRUB configuration..."
sudo cp -r "$DOTFILES_DIR/grub/"* /etc/default/
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Setup complete!"
