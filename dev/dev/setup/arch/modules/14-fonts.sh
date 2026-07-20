#!/usr/bin/env bash
# 14-fonts.sh — Fonts and typefaces (all categories)
# Idempotent: all package installs use --needed; fc-cache skips if up to date.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 14: Fonts ==="

# -- Nerdfonts (icon sets) -------------------------------------------
pacmani \
  ttf-firacode-nerd \
  ttf-jetbrains-mono-nerd \
  ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-mono

# -- Noto fonts (international coverage) -----------------------------
pacmani \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  noto-fonts-extra

# -- Icon / Symbol fonts ---------------------------------------------
pacmani otf-font-awesome

# -- Terminal / Legacy fonts -----------------------------------------
pacmani terminus-font

# -- Rebuild font cache (idempotent) --------------------------------
if fc-cache --version &>/dev/null; then
  log "rebuilding font cache ..."
  fc-cache -f
fi

ok "fonts done"
