#!/usr/bin/env bash
# 00-mirrors.sh — Configure pacman mirrors (reflector)
# Idempotent: skips if mirrors already set and country matches.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 00: Mirror configuration ==="

# Skip if /etc/pacman.d/mirrorlist already has our preferred country
if grep -q '^## .*United States' /etc/pacman.d/mirrorlist 2>/dev/null; then
  ok "mirrors already configured for United States"
else
  log "ranking mirrors by speed (United States) ..."
  sudo reflector \
    --country 'United States' \
    --latest 10 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist
  ok "mirrors updated"
fi

pacsync
