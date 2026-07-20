#!/usr/bin/env bash
# 03-shell.sh — Shell environment: zsh, terminals, tmux, prompt
# Idempotent: package installs use --needed; config steps check first.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 03: Shell environment ==="

# -- Shell -----------------------------------------------------------
pacmani zsh

# -- Terminals -------------------------------------------------------
pacmani ghostty foot kitty

# -- Tmux ------------------------------------------------------------
pacmani tmux

# -- Utilities -------------------------------------------------------
pacmani stow fastfetch

# -- AUR: shell extras -----------------------------------------------
parui zinit

# -- AUR: ghostty nautilus extension --------------------------------
parui ghostty-nautilus
