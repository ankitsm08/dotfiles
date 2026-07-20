#!/usr/bin/env bash
# 05-dev.sh — Development tools: editors, languages, build tools, VCS
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 05: Development tools ==="

# -- Version control -------------------------------------------------
pacmani \
  git git-credential-oauth git-delta git-graph \
  gitleaks lazygit

# -- Editors ---------------------------------------------------------
pacmani neovim vim
parui vscodium-bin zed

# -- Languages / Runtimes --------------------------------------------
pacmani \
  python-pip uv \
  rustup \
  clang cmake ninja bear \
  lua51 luarocks \
  ruby ruby-erb

# -- Formatters / Linters --------------------------------------------
pacmani \
  prettier stylua tree-sitter-cli ruff

# -- Build / Productivity tools --------------------------------------
pacmani just hyperfine entr

# -- SVG / Image tools -----------------------------------------------
pacmani resvg

# -- Code screenshot / sharing ---------------------------------------
pacmani silicon

# -- Misc dev --------------------------------------------------------
pacmani zeal forgejo-cli

# -- AUR: dev tools --------------------------------------------------
parui \
  fnm-bin \
  google-java-format \
  lazyssh-bin \
  ngrok \
  lazyenv-bin \
  opencode \
  qman

# -- Install fnm completions (after install) ------------------------
if has_cmd fnm && [[ ! -f "$HOME/.fnm/fnm.zsh" ]]; then
  log "initializing fnm ..."
  fnm completions --shell zsh > "$HOME/.fnm/fnm.zsh" 2>/dev/null || true
fi

ok "development tools done"
