#!/usr/bin/env bash
# 15-services.sh — Enable and start systemd services
# Idempotent: checks before enabling; skips if already enabled.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 15: System services ==="

enable_service() {
  local svc="$1"
  if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
    ok "service already enabled: $svc"
  else
    log "enabling service: $svc"
    sudo systemctl enable --now "$svc"
  fi
}

enable_user_service() {
  local svc="$1"
  if systemctl --user is-enabled --quiet "$svc" 2>/dev/null; then
    ok "user service already enabled: $svc"
  else
    log "enabling user service: $svc"
    systemctl --user enable --now "$svc"
  fi
}

# -- Core system services --------------------------------------------
enable_service NetworkManager.service
enable_service bluetooth.service
enable_service iwd.service
enable_service sshd.service
enable_service tailscaled.service

# -- Display manager -------------------------------------------------
enable_service sddm.service

# -- Power management ------------------------------------------------
enable_service power-profiles-daemon.service
enable_service auto-cpufreq.service

# -- Docker ----------------------------------------------------------
if has_pkg docker; then
  enable_service docker.service
fi

# -- Syncthing (user) ------------------------------------------------
if has_pkg syncthing; then
  enable_user_service syncthing.service
fi

# -- Voxtype (TTS daemon) --------------------------------------------
if has_pkg voxtype-bin; then
  enable_service voxtype.service
fi

# -- SwayOSD ---------------------------------------------------------
if has_pkg swayosd; then
  enable_service swayosd-libinput-backend.service
fi

# -- Sunshine (game streaming) --------------------------------------
# Sunshine needs cap_sys_admin+p capability set, then user service
if has_pkg sunshine-bin; then
  if command -v sunshine &>/dev/null && ! getcap "$(which sunshine)" 2>/dev/null | grep -q cap_sys_admin; then
    log "setting capabilities for sunshine ..."
    sudo setcap cap_sys_admin+p "$(readlink -f "$(which sunshine)")"
  fi
  enable_user_service sunshine.service
fi

ok "system services done"
