#!/usr/bin/env bash
# 01-base.sh — System foundation: kernel, firmware, drivers, networking,
#               audio, display manager, core CLI utilities, system services.
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 01: Base system ==="

# -- Kernel & firmware -----------------------------------------------
pacmani \
  linux linux-headers linux-zen linux-zen-headers \
  linux-firmware amd-ucode

# -- Bootloader ------------------------------------------------------
pacmani grub efibootmgr

# -- Core system -----------------------------------------------------
pacmani \
  base base-devel \
  man-db man-pages \
  nano nano-syntax-highlighting less ex-vi-compat

# -- Networking ------------------------------------------------------
pacmani \
  networkmanager network-manager-applet \
  iwd wireless_tools iw \
  bind nmap \
  tailscale \
  openbsd-netcat

# -- Bluetooth -------------------------------------------------------
pacmani bluez bluez-utils blueman bluetui

# -- Audio / PipeWire ------------------------------------------------
pacmani \
  pipewire pipewire-alsa pipewire-jack pipewire-pulse \
  libpulse \
  wireplumber \
  gst-plugin-pipewire gst-libav gst-plugins-ugly \
  pavucontrol helvum \
  sof-firmware

# -- Display Manager -------------------------------------------------
pacmani sddm

# -- Graphics drivers ------------------------------------------------
pacmani \
  vulkan-intel vulkan-radeon vulkan-nouveau \
  xf86-video-amdgpu xf86-video-ati xf86-video-nouveau \
  intel-media-driver libva-intel-driver \
  radeontop

# -- X11 fallback (needed by some apps) ------------------------------
pacmani xorg-server xorg-xinit

# -- Compositors -----------------------------------------------------
pacmani cage

# -- Filesystems & storage -------------------------------------------
pacmani \
  ntfs-3g fuseiso \
  udiskie mtpfs gvfs-mtp gvfs-gphoto2 gvfs-nfs gvfs-smb gvfs-wsdd

# -- System utilities ------------------------------------------------
pacmani \
  rsync unzip zip wget \
  pacman-contrib expac pkgfile \
  reflector bc dos2unix \
  brightnessctl evtest wev wtype \
  wl-clipboard wl-clip-persist \
  slurp grim \
  power-profiles-daemon powertop \
  smartmontools \
  zram-generator

# -- Portal / Auth / Flatpak -----------------------------------------
pacmani \
  xdg-utils \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  polkit-kde-agent hyprpolkitagent \
  gnome-keyring seahorse \
  flatpak

# -- Virtual camera --------------------------------------------------
pacmani v4l2loopback-dkms v4l2loopback-utils

# -- TTS / OCR -------------------------------------------------------
pacmani \
  tesseract tesseract-data-eng \
  espeak-ng espeakup speech-dispatcher \
  rhvoice rhvoice-language-english rhvoice-voice-alan rhvoice-voice-slt

# -- Theming ---------------------------------------------------------
pacmani gnome-themes-extra xcur2png

# -- Web server ------------------------------------------------------
pacmani caddy

# -- Camera controls -------------------------------------------------
pacmani cameractrls

# -- KDE Frameworks integration --------------------------------------
pacmani frameworkintegration

# -- AUR: base extras ------------------------------------------------
parui auto-cpufreq

# -- Init pkgfile database -------------------------------------------
if [[ ! -f /var/cache/pkgfile/pkgfile.db ]]; then
  log "initializing pkgfile database ..."
  sudo pkgfile --update
fi

# -- Init flatpak (user) --------------------------------------------
if ! flatpak list &>/dev/null; then
  log "initializing flatpak ..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
fi

ok "base system done"
