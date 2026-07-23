#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-hyprsunset-state"

init_state() {
  temp=$(hyprctl hyprsunset temperature 2>/dev/null)
  [ -z "$temp" ] && temp=3600
  id=$(hyprctl hyprsunset profile 2>/dev/null | grep "^Identity:" | awk '{print $2}')
  [ -z "$id" ] && id=false
  printf "temperature=%s\nidentity=%s\n" "$temp" "$id" > "$STATE_FILE"
}

case "${1:-}" in
  --up|--down)
    [ -f "$STATE_FILE" ] || init_state
    temperature=$(grep "^temperature=" "$STATE_FILE" | cut -d= -f2)
    [ -z "$temperature" ] && temperature=3600

    step=100
    if [ "$1" = "--up" ]; then
      new=$((temperature + step))
      [ "$new" -gt 8000 ] && new=8000
    else
      new=$((temperature - step))
      [ "$new" -lt 1000 ] && new=1000
    fi

    hyprctl hyprsunset temperature "$new" >/dev/null 2>&1
    hyprctl hyprsunset identity false >/dev/null 2>&1

    printf "temperature=%s\nidentity=false\n" "$new" > "$STATE_FILE"
    pkill -RTMIN+10 waybar 2>/dev/null
    ;;
  --toggle-identity)
    [ -f "$STATE_FILE" ] || init_state
    temperature=$(grep "^temperature=" "$STATE_FILE" | cut -d= -f2)
    identity=$(grep "^identity=" "$STATE_FILE" | cut -d= -f2)
    [ -z "$temperature" ] && temperature=3600

    if [ "$identity" = "true" ]; then
      new_identity="false"
    else
      new_identity="true"
    fi

    hyprctl hyprsunset identity "$new_identity" >/dev/null 2>&1

    printf "temperature=%s\nidentity=%s\n" "$temperature" "$new_identity" > "$STATE_FILE"
    pkill -RTMIN+10 waybar 2>/dev/null
    ;;
  --refresh)
    identity=$(grep "^identity=" "$STATE_FILE" 2>/dev/null | cut -d= -f2)
    [ -z "$identity" ] && identity=false
    temp=$(hyprctl hyprsunset temperature 2>/dev/null)
    [ -z "$temp" ] && temp=3600
    printf "temperature=%s\nidentity=%s\n" "$temp" "$identity" > "$STATE_FILE"
    pkill -RTMIN+10 waybar 2>/dev/null
    ;;
  --reset)
    hyprctl hyprsunset reset >/dev/null 2>&1
    rm -f "$STATE_FILE"
    init_state
    pkill -RTMIN+10 waybar 2>/dev/null
    ;;
  *)
    [ -f "$STATE_FILE" ] || init_state
    temperature=$(grep "^temperature=" "$STATE_FILE" | cut -d= -f2)
    identity=$(grep "^identity=" "$STATE_FILE" | cut -d= -f2)
    [ -z "$temperature" ] && temperature=3600
    [ -z "$identity" ] && identity=false

    if [ "$identity" = "true" ]; then
      icon=""
      text="$icon"
      class="identity"
      tooltip="Identity mode — no filter"
    else
      if [ "$temperature" -lt 4000 ]; then
        icon=""
        class="warm"
      elif [ "$temperature" -lt 5500 ]; then
        icon=""
        class="neutral"
      elif [ "$temperature" -lt 7000 ]; then
        icon=""
        class="cool"
      else
        icon=""
        class="cold"
      fi
      temp_k=$(echo "scale=1; $temperature / 1000" | bc)
      text="${temp_k}K $icon"
      tooltip="Temperature: ${temperature}K"
    fi

    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$tooltip"
    ;;
esac
