#!/usr/bin/env bash
# 16-sysctl.sh — Apply kernel parameters via sysctl.d
# Idempotent: checks if config already matches before writing.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log "=== 16: Kernel parameters ==="

SYSCTL_FILE="/etc/sysctl.d/99-custom.conf"

# Define desired kernel parameters
declare -A SYSCTL_PARAMS
SYSCTL_PARAMS=(
  ["vm.swappiness"]="10"
  ["vm.vfs_cache_pressure"]="50"
  ["net.core.default_qdisc"]="fq"
  ["net.ipv4.tcp_congestion_control"]="bbr"
  ["kernel.nmi_watchdog"]="0"
  ["kernel.core_pattern"]="|/bin/false"
)

write_needed=false

if [[ ! -f "$SYSCTL_FILE" ]]; then
  write_needed=true
else
  for key in "${!SYSCTL_PARAMS[@]}"; do
    expected="$key = ${SYSCTL_PARAMS[$key]}"
    if ! grep -q "$expected" "$SYSCTL_FILE" 2>/dev/null; then
      write_needed=true
      break
    fi
  done
fi

if [[ "$write_needed" == true ]]; then
  log "writing $SYSCTL_FILE ..."
  sudo tee "$SYSCTL_FILE" >/dev/null <<'EOF'
# Custom kernel parameters — applied via sysctl.d
# Tune for desktop/low-latency workload

vm.swappiness=10
vm.vfs_cache_pressure=50

# TCP: BBR congestion control + fq qdisc
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

# Disable NMI watchdog (saves power, ~1 wakeup/sec)
kernel.nmi_watchdog=0

# Disable core dumps
kernel.core_pattern=|/bin/false
EOF
  sudo sysctl --system
  ok "kernel parameters applied"
else
  ok "kernel parameters already configured"
fi
