#!/usr/bin/env bash
# 02-paru.sh — Install paru (AUR helper) and yay
# Idempotent: checks for existence before building.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 02: AUR helpers ==="

install_paru() {
  if command -v paru &>/dev/null; then
    ok "paru already installed"
    return 0
  fi
  log "building paru from AUR ..."
  sudo pacman -S --needed --noconfirm base-devel git
  local tmpdir
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  cd "$tmpdir/paru"
  makepkg -si --noconfirm
  rm -rf "$tmpdir"
  ok "paru installed"
}

install_yay() {
  if command -v yay &>/dev/null; then
    ok "yay already installed"
    return 0
  fi
  log "building yay from AUR ..."
  local tmpdir
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  cd "$tmpdir/yay"
  makepkg -si --noconfirm
  rm -rf "$tmpdir"
  ok "yay installed"
}

install_paru
install_yay
