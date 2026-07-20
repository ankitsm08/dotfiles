#!/usr/bin/env bash
# 08-apps-office.sh — Productivity and office applications
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 08: Office & Productivity ==="

# -- Office suite ----------------------------------------------------
pacmani libreoffice-fresh

# -- Notes / Knowledge -----------------------------------------------
pacmani obsidian

# -- Email / Calendar ------------------------------------------------
pacmani thunderbird

# -- PDF / Documents -------------------------------------------------
pacmani qpdf

# -- Audiobook / Speech ----------------------------------------------
pacmani voxtype-bin

# -- AUR: office extras ----------------------------------------------
parui \
  fend-bin \
  sioyek-appimage \
  geogebra

# -- Sioyek config directory ----------------------------------------
mkdir -p "$HOME/.config/sioyek"

ok "office & productivity done"
