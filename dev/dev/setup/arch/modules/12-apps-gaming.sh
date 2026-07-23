#!/usr/bin/env bash
# 12-apps-gaming.sh — Gaming: Steam, Wine, emulators, game tools
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 12: Gaming ==="

# -- Steam -----------------------------------------------------------
pacmani steam

# -- Wine / Proton layer ---------------------------------------------
# bottles handles Wine internally; wine and winetricks are deps, not explicit
pacmani lutris bottles

# -- GameScope (game-specific compositor) ----------------------------
pacmani gamescope

# -- Performance overlay ---------------------------------------------
pacmani mangohud

# -- Sunshine (game streaming host) ---------------------------------
parui sunshine-bin

# -- AUR: gaming extras ----------------------------------------------
parui ruffle-nightly-bin

ok "gaming done"
