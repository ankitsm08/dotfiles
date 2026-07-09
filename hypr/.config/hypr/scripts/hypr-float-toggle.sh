#!/usr/bin/env bash

SPECIAL="floatstash"

CUR_WS=$(hyprctl activeworkspace -j | jq '.id')

# Get floating windows in current workspace
FLOAT_CUR=$(hyprctl clients -j | jq -r \
  ".[] | select(.floating == true and .workspace.id == $CUR_WS) | .address")

# If there are floating windows in current workspace
if [[ -n "$FLOAT_CUR" ]]; then
  # Stash floating windows from current workspace
  for addr in $FLOAT_CUR; do
    hyprctl dispatch "hl.dsp.window.move({ workspace = 'special:$SPECIAL', window = 'address:$addr', follow = false })"
  done
else
  # Else restore floating windows from special workspace
  FLOAT_SPECIAL=$(hyprctl clients -j | jq -r \
    ".[] | select(.floating == true and .workspace.name == \"special:$SPECIAL\") | .address")

  LAST_ADDR=""

  for addr in $FLOAT_SPECIAL; do
    hyprctl dispatch "hl.dsp.window.move({ workspace = '$CUR_WS', window = 'address:$addr', follow = false })"
    LAST_ADDR="$addr"
  done

  # Focus the last restored floating window
  if [[ -n "$LAST_ADDR" ]]; then
    hyprctl dispatch "hl.dsp.focus({ window = 'address:$LAST_ADDR' })"
  fi
fi
