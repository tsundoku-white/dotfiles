#!/usr/bin/env bash
# Snapshot the current system state into ~/dotfiles so install.sh can restore it.
set -e
cd "$(dirname "$(readlink -f "$0")")"

echo "==> Packages"
pacman -Qqen | sort > pkglist-repo.txt
pacman -Qqem | sort > pkglist-aur.txt
if command -v flatpak &> /dev/null; then
    flatpak list --app --columns=application > pkglist-flatpak.txt
fi

echo "==> Services"
systemctl list-unit-files --state=enabled --type=service,socket,timer --no-legend \
    | awk '{print $1}' | sort > services-system.txt
systemctl --user list-unit-files --state=enabled --no-legend \
    | awk '{print $1}' | sort > services-user.txt

echo "==> GTK / gsettings"
dconf dump /org/gnome/desktop/interface/ > gsettings-interface.ini

echo "==> Changes since last commit"
git --no-pager diff --stat -- 'pkglist-*.txt' 'services-*.txt' gsettings-interface.ini || true
