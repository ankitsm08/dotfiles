#!/usr/bin/env bash

WALL_DIR="$HOME/.config/wallpapers"
HIST_FILE="$HOME/.cache/wallpaper_history"
POS_FILE="$HOME/.cache/last_transition_pos"
HISTORY_SIZE=8

MODE="menu"

# PARSE ARGUMENTS
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--random)
      MODE="random"
      ;;
    --reverse)
      MODE="reverse"
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

touch "$HIST_FILE"

if [[ "$MODE" == "reverse" ]]; then
  # REVERSE MODE
  mapfile -t history < "$HIST_FILE"
  [[ ${#history[@]} -lt 2 ]] && exit 0

  img="${history[1]}"

  {
    printf "%s\n" "${history[@]:1}"
    printf "%s\n" "${history[0]}"
  } | head -n "$HISTORY_SIZE" > "$HIST_FILE.tmp"

  mv "$HIST_FILE.tmp" "$HIST_FILE"
elif [[ "$MODE" == "random" ]]; then
  # RANDOM SELECTION
  mapfile -t history < "$HIST_FILE"

  find_args=("$WALL_DIR" -type f)
  for h in "${history[@]}"; do
    find_args+=(! -path "$h")
  done

  img=$(find "${find_args[@]}" | shuf -n 1)

  if [[ -z "$img" ]]; then
    img=$(find "$WALL_DIR" -type f | shuf -n 1)
    : > "$HIST_FILE"
  fi
elif [[ "$MODE" == "menu" ]]; then
  # MENU SELECTION
  img=$(find "$WALL_DIR" -type f | sort | vicinae dmenu -p "Pick a wallpaper...")
fi

[[ -z "$img" ]] && exit 0

# TRANSITION POSITION
positions=(
  center center center top left right bottom
  top-left top-right bottom-left bottom-right
)

last_pos=""
[[ -f "$POS_FILE" ]] && last_pos=$(<"$POS_FILE")

pos=$(printf "%s\n" "${positions[@]}" \
    | grep -Fxv "$last_pos" \
  | shuf -n 1)

dur=$(printf "1.2\n1.4\n1.6\n1.8\n2.0\n2.2\n2.4\n2.6\n2.8\n" | shuf -n 1)

# APPLY WALLPAPER
awww img "$img" \
  --transition-type grow \
  --transition-fps 120 \
  --transition-bezier .4,1.2,.65,.4 \
  --transition-duration $dur \
  --transition-pos "$pos"

echo "$pos" > "$POS_FILE"

# UPDATE HISTORY (skip for reverse)
if [[ "$MODE" != "reverse" ]]; then
  printf "%s\n%s\n" "$img" "$(cat "$HIST_FILE")" \
    | awk '!seen[$0]++' \
    | head -n "$HISTORY_SIZE" > "$HIST_FILE.tmp"

  mv "$HIST_FILE.tmp" "$HIST_FILE"
fi
