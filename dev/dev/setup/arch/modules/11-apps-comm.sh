#!/usr/bin/env bash
# 11-apps-comm.sh — Communication and messaging apps
# Idempotent: all package installs use --needed.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 11: Communication ==="

# -- Messaging -------------------------------------------------------
pacmani discord telegram-desktop signal-desktop

# -- Matrix ----------------------------------------------------------
pacmani element-desktop

# -- Remote desktop --------------------------------------------------
pacmani remmina
parui rustdesk-bin

# -- AUR: comm extras ------------------------------------------------
parui gotify-cli-bin gotify-desktop

ok "communication apps done"
