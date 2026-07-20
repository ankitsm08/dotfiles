#!/usr/bin/env bash
# 13-apps-misc.sh — Everything else not fitting other categories
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 13: Miscellaneous apps ==="

# -- Web browsers ----------------------------------------------------
parui zen-browser-bin brave-bin
pacmani torbrowser-launcher

# -- Cloudflare ------------------------------------------------------
parui cloudflare-warp-bin cloudflared

# -- Password management ---------------------------------------------
pacmani age bitwarden
parui rbw

# -- File sharing / sync ---------------------------------------------
pacmani syncthing
parui localsend-bin

# -- Android ---------------------------------------------------------
pacmani android-file-transfer
parui android-studio

# -- AI / LLM --------------------------------------------------------
parui lmstudio-bin
pacmani aichat gemini-cli

# -- 2FA --------------------------------------------------------------
parui ente-auth-bin

# -- Weather ---------------------------------------------------------
parui weathr-bin

# -- AUR: fun / misc -------------------------------------------------
parui \
  awww \
  freesmlauncher-bin \
  seanime-denshi \
  elecwhat-bin \
  cliamp-bin \
  smassh-bin \
  fvs2 \
  wayscriber-bin \
  goldfish \
  tsui \
  warp-plus-bin \
  impala

# -- Barcode / QR ----------------------------------------------------
pacmani zbar

# -- LaTeX -----------------------------------------------------------
pacmani \
  texlive-basic texlive-context \
  texlive-fontsextra texlive-fontsrecommended

# -- Audio playback (misc) -------------------------------------------
parui voxtype-bin

# -- Device control --------------------------------------------------
pacmani ddcutil
parui ddcui

# -- Astro / Space ---------------------------------------------------
pacmani astroterm

ok "miscellaneous apps done"
