#!/usr/bin/env bash
# 17-dotfiles.sh — Deploy dotfiles via GNU Stow
# Idempotent: stow is idempotent (--restow, --no-folding).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 17: Dotfiles ==="

DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  warn "dotfiles directory not found at $DOTFILES_DIR — cloning?"
  warn "  git clone <your-repo> $DOTFILES_DIR"
  warn "skipping dotfile deployment"
  exit 0
fi

# Find all stow packages (directories that are stow packages)
# A stow package is a directory whose contents should be symlinked to $HOME/..
stow_packages=()
for item in "$DOTFILES_DIR"/*; do
  if [[ -d "$item" ]]; then
    local name
    name="$(basename "$item")"
    # Skip .git, dev/ (unless it's a stow package), etc.
    if [[ "$name" == ".git" ]]; then
      continue
    fi
    stow_packages+=("$name")
  fi
done

if [[ ${#stow_packages[@]} -eq 0 ]]; then
  warn "no stow packages found in $DOTFILES_DIR"
  exit 0
fi

log "found ${#stow_packages[@]} stow packages: ${stow_packages[*]}"

# Stow from $DOTFILES_DIR to $HOME
cd "$DOTFILES_DIR"

for pkg in "${stow_packages[@]}"; do
  # Check if already stowed: look for symlink in parent dir
  local sample_file
  sample_file=$(find "$pkg" -type f -o -type l | head -1 2>/dev/null || true)
  if [[ -z "$sample_file" ]]; then
    warn "empty stow package: $pkg — skipping"
    continue
  fi
  # Relative path from stow package target
  local rel_path="${sample_file#$pkg/}"
  local target_path="$HOME/$rel_path"
  if [[ -L "$target_path" ]]; then
    local link_target
    link_target=$(readlink "$target_path")
    if [[ "$link_target" == "$DOTFILES_DIR/$pkg/$rel_path" ]] || \
      [[ "$link_target" == "../$pkg/$rel_path" ]]; then
      ok "already stowed: $pkg"
      continue
    fi
  fi
  log "stowing: $pkg"
  stow --restow --no-folding "$pkg" 2>/dev/null || {
    warn "stow failed for $pkg — may have conflicts; try stow --adopt"
  }
done

# -- Yazi (Catppuccin flavor) ---------------------------------------
if has_cmd ya && [[ ! -d "$HOME/.local/share/yazi/flavors/catppuccin-mocha" ]]; then
  log "installing yazi catppuccin flavors ..."
  ya pack --add yazi-rs/flavors:catppuccin-mocha 2>/dev/null || true
fi

ok "dotfiles deployed"
