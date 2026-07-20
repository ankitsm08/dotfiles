#!/usr/bin/env bash
# 06-docker.sh — Docker engine and container management tools
# Idempotent: checks before adding user to group, etc.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 06: Docker ==="

# -- Docker engine ---------------------------------------------------
pacmani docker docker-compose lazydocker

# -- Add user to docker group ----------------------------------------
if ! groups "$USER" | grep -q docker; then
  log "adding $USER to docker group ..."
  sudo usermod -aG docker "$USER"
  warn "log out and back in for docker group changes to take effect"
else
  ok "$USER is already in docker group"
fi

# -- Enable docker socket for lazydocker ----------------------------
if [[ ! -S /var/run/docker.sock ]] && [[ ! -S /run/docker.sock ]]; then
  warn "docker socket not found — start docker or reboot after group assignment"
fi
