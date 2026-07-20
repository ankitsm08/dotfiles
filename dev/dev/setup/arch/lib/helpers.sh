#!/usr/bin/env bash
# helpers.sh — Idempotent install wrappers for Arch Linux bootstrap
#
# Provides:
#   pacmani  <pkg> [pkg ...]  — pacman -S --needed --noconfirm wrapper
#   parui    <pkg> [pkg ...]  — paru -S --needed --noconfirm wrapper
#   has_pkg  <pkg>             — true if package is installed
#   pacsync                    — pacman -Sy (only if db is stale)
#
# All functions are idempotent. Safe to call repeatedly.

set -euo pipefail

# -- Colors ----------------------------------------------------------
readonly RST='\033[0m'   BLD='\033[1m'   DIM='\033[2m'
readonly RED='\033[31m'  GRN='\033[32m'  YLW='\033[33m'  CYN='\033[36m'

log()   { echo -e "${DIM}[bootstrap]${RST}${BLD}${CYN} $*${RST}"; }
ok()    { echo -e "${GRN}  ✓${RST}${DIM} $*${RST}"; }
warn()  { echo -e "${YLW}  ?${RST}${DIM} $*${RST}"; }
fail()  { echo -e "${RED}  ✗${RST}${DIM} $*${RST}"; }

# -- Package helpers -------------------------------------------------

# pacsync — sync package databases if older than 1 hour
pacsync() {
  local db_age
  if [[ -f /var/lib/pacman/sync/core.db ]]; then
    db_age=$(($(date +%s) - $(stat -c %Y /var/lib/pacman/sync/core.db)))
    if (( db_age < 3600 )); then
      ok "package database is fresh (<1h)"
      return 0
    fi
  fi
  log "syncing package databases ..."
  sudo pacman -Sy --noconfirm
}

# pacmani — install packages with pacman (idempotent via --needed)
pacmani() {
  local pkgs=("$@")
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    ok "all pacman packages already installed: ${pkgs[*]}"
    return 0
  fi
  log "installing (pacman): ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
}

# parui — install packages with paru (idempotent via --needed)
parui() {
  if ! command -v paru &>/dev/null; then
    warn "paru not installed — skipping AUR install: $*"
    return 1
  fi
  local pkgs=("$@")
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    ok "all AUR packages already installed: ${pkgs[*]}"
    return 0
  fi
  log "installing (AUR): ${missing[*]}"
  paru -S --needed --noconfirm "${missing[@]}"
}

# has_pkg — check if package is installed
has_pkg() {
  pacman -Qi "$1" &>/dev/null
}

# has_cmd — check if command is available
has_cmd() {
  command -v "$1" &>/dev/null
}
