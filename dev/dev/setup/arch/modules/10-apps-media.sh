#!/usr/bin/env bash
# 10-apps-media.sh — Media playback, streaming, audio processing, torrent
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 10: Media apps ==="

# -- Media playback --------------------------------------------------
pacmani mpv

# -- Audio processing ------------------------------------------------
pacmani \
  easyeffects \
  lsp-plugins-lv2 \
  calf \
  wiremix \
  sox

# -- Audio visualizer ------------------------------------------------
pacmani cava

# -- Torrents ---------------------------------------------------------
pacmani qbittorrent

# -- Video downloading -----------------------------------------------
pacmani yt-dlp

# -- Streaming -------------------------------------------------------
pacmani obs-studio moonlight-qt

# -- HandBrake (video transcoding) -----------------------------------
pacmani handbrake

# -- Spotify ---------------------------------------------------------
parui spotify-launcher spotube-bin

# -- YouTube frontend ------------------------------------------------
parui freetube-bin

# -- Spicetify (Spotify theming) -------------------------------------
parui spicetify-cli spicetify-cli-debug

# -- Python audio ----------------------------------------------------
pacmani python-pyaudio

# -- AUR: audio extras -----------------------------------------------
parui audiosource surge-bin

ok "media apps done"
