#!/usr/bin/env bash
# 09-apps-creative.sh — Creative / design / media production
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 09: Creative tools ==="

# -- 3D / CAD --------------------------------------------------------
pacmani blender freecad

# -- Image editing ---------------------------------------------------
pacmani gimp inkscape krita

# -- Pixel art -------------------------------------------------------
pacmani libresprite
parui pixelorama-bin

# -- Video editing ---------------------------------------------------
pacmani kdenlive

# -- Image viewers / converters --------------------------------------
pacmani \
  gthumb converseen \
  oculante

# -- Audio production ------------------------------------------------
pacmani tenacity

# -- Game development ------------------------------------------------
pacmani godot

# -- AUR: creative extras --------------------------------------------
parui \
  rapidraw-bin \
  cavasik

ok "creative tools done"
