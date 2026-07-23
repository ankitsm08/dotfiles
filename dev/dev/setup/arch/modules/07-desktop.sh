#!/usr/bin/env bash
# 07-desktop.sh — Hyprland desktop environment, theming, UI tools
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 07: Desktop environment ==="

# -- Hyprland stack --------------------------------------------------
pacmani \
  hyprland \
  hyprlock hypridle hyprshutdown hyprsunset hyprpicker \
  hyprgraphics hyprlang hyprutils hyprtoolkit aquamarine \
  uwsm

# -- AUR: Hyprland extras --------------------------------------------
parui waybar-git wlogout hyprmoncfg hyprqt6engine

# -- Notifications ---------------------------------------------------
pacmani swaync dunst

# -- Launchers / Menus -----------------------------------------------
pacmani rofi rofi-calc wofi
parui vicinae-bin

# -- OSD / Media keys ------------------------------------------------
pacmani swayosd cliphist

# -- Screen recording / casting --------------------------------------
pacmani wl-screenrec obs-studio

# -- Screenshots -----------------------------------------------------
pacmani grim slurp swappy satty flameshot

# -- Clipboard -------------------------------------------------------
pacmani wl-clipboard wl-clip-persist cliphist

# -- File manager ----------------------------------------------------
pacmani \
  nautilus nautilus-python nautilus-image-converter \
  thunar thunar-archive-plugin thunar-media-tags-plugin \
  thunar-shares-plugin thunar-vcs-plugin thunar-volman \
  xarchiver file-roller

# -- GTK / Qt theming ------------------------------------------------
pacmani \
  qt5ct qt6ct \
  qt5-wayland qt6-wayland \
  kvantum kvantum-qt5 \
  nwg-look \
  papirus-icon-theme \
  adwaita-qt5 adwaita-qt6 \
  gnome-themes-extra \
  xcur2png

# -- AUR: theme packages ---------------------------------------------
parui \
  catppuccin-gtk-theme-mocha \
  catppuccin-cursors-mocha \
  catppuccin-sddm-theme-mocha \
  catppuccin-mocha-grub-theme-git \
  nordzy-hyprcursors \
  darkly-bin \
  pacsea-bin \
  quickshell \
  gnome-themes-extra-gtk2

# -- Image viewers / previews ----------------------------------------
pacmani imv chafa sushi

# -- Waydroid (Android in container) --------------------------------
pacmani waydroid
parui waydroid-helper

# -- Vulkan overlay --------------------------------------------------
parui vkbasalt-cli

# -- CMatrix / terminal fun ------------------------------------------
parui cmatrix-git

# -- Misc desktop utilities ------------------------------------------
pacmani \
  dragon-drop yad \
  wtype wev \
  bluetui

# -- Ensure catppuccin SDDM theme is active -------------------------
if [[ -d /usr/share/sddm/themes/catppuccin-mocha ]] && \
  { [[ ! -f /etc/sddm.conf ]] || ! grep -q 'catppuccin-mocha' /etc/sddm.conf 2>/dev/null; }; then
  log "setting SDDM theme to catppuccin-mocha ..."
  sudo mkdir -p /etc/sddm.conf.d
  echo -e "[Theme]\nCurrent=catppuccin-mocha" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
  ok "SDDM theme set"
fi

ok "desktop environment done"
