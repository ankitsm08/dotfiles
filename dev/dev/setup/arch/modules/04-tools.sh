#!/usr/bin/env bash
# 04-tools.sh — Modern CLI utilities, file management, system tools
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 04: CLI tools ==="

# -- Archive / compression -------------------------------------------
pacmani 7zip unzip zip

# -- Modern replacements ---------------------------------------------
pacmani \
  bat eza fd ripgrep fzf \
  procs dust duf \
  dog jq yq \
  glow fx jless \
  pastel chafa lolcat genact \
  xh

# -- System monitoring -----------------------------------------------
pacmani \
  bottom btop htop \
  nload s-tui gping

# -- File management -------------------------------------------------
pacmani \
  yazi tabiew \
  rclone copyparty \
  ffmpegthumbnailer tumbler

# -- Misc CLI --------------------------------------------------------
pacmani \
  entr hyperfine just \
  vim \
  zoxide \
  pik jolt \
  ttyd

# -- Download managers -----------------------------------------------
pacmani aria2 wget

# -- AUR: CLI extras -------------------------------------------------
parui \
  cht.sh-git \
  tlrc-bin \
  imgcat-bin \
  patool \
  downgrade

ok "CLI tools done"
