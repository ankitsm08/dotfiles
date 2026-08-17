#!/usr/bin/env bash
# backlight-ddc.sh - DDC/CI brightness for an external monitor via ddcutil.
#
# Used by the swaync "Monitor" slider widget:
#   cmd_setter: ~/.config/swaync/scripts/backlight-ddc.sh set $value
#   cmd_getter: ~/.config/swaync/scripts/backlight-ddc.sh get
#
# Values are normalized to 0-100 regardless of the monitor's native max.
# `get` results are cached so opening the control center doesn't re-query
# the monitor over DDC/CI (slow) on every toggle.

FEATURE=10 # VCP 0x10 = Brightness
CACHE_FILE="/tmp/swaync-backlight-ddc-cache"
CACHE_TTL=5

get_raw() {
  local displays
  displays=$(ddcutil detect --terse 2>/dev/null | grep -c "^Display")
  if [[ "$displays" -eq 1 ]]; then
    ddcutil getvcp "$FEATURE" -t 2>/dev/null
  elif [[ "$displays" -gt 1 ]]; then
    ddcutil getvcp "$FEATURE" -t --display 1 2>/dev/null
  fi
}

get_max() {
  echo "$(get_raw)" | awk '{print $5}'
}

cache_get() {
  [[ -f "$CACHE_FILE" ]] || return 1
  local ts value
  ts=$(sed -n '1p' "$CACHE_FILE")
  value=$(sed -n '2p' "$CACHE_FILE")
  [[ "$ts" =~ ^[0-9]+$ ]] || return 1
  [[ "$value" =~ ^[0-9]+$ ]] || return 1
  (( $(date +%s) - ts < CACHE_TTL )) || return 1
  echo "$value"
}

cache_put() {
  printf '%s\n%s\n' "$(date +%s)" "$1" > "$CACHE_FILE"
}

case "${1:-}" in
  get)
    cached=$(cache_get)
    if [[ -n "$cached" ]]; then
      echo "$cached"
      exit 0
    fi

    raw=$(get_raw)
    cur=$(echo "$raw" | awk '{print $4}')
    max=$(echo "$raw" | awk '{print $5}')

    if [[ -z "$cur" || -z "$max" || "$max" -le 0 ]]; then
      echo 0
      exit 0
    fi

    value=$((cur * 100 / max))
    cache_put "$value"
    echo "$value"
    ;;

  set)
    norm="${2:-}"
    [[ -z "$norm" ]] && exit 1
    [[ "$norm" -lt 0 ]] && norm=0
    [[ "$norm" -gt 100 ]] && norm=100

    value=$norm
    max=$(get_max)
    if [[ -n "$max" && "$max" -gt 0 && "$max" -ne 100 ]]; then
      value=$((norm * max / 100))
    fi

    ddcutil setvcp "$FEATURE" "$value" 2>/dev/null
    cache_put "$norm"
    ;;

  *)
    echo "Usage: $0 {get|set VALUE}" >&2
    exit 1
    ;;
esac
