#!/bin/bash

if command -v hyprctl &>/dev/null; then
  read -r monitor move_x move_y width height < <(
    hyprctl monitors -j | jq -r '
      map(. + {
        eff_w: (if .transform % 2 != 0 then .height else .width end),
        eff_h: (if .transform % 2 != 0 then .width else .height end)
      })
      | (map(.x) | min) as $min_x
      | (map(.y) | min) as $min_y
      | (map(.x + .eff_w) | max) as $max_x
      | (map(.y + .eff_h) | max) as $max_y
      | (sort_by(.x, .y) | first) as $anchor
      | "\($anchor.name) \($min_x - $anchor.x) \($min_y - $anchor.y) \($max_x - $min_x) \($max_y - $min_y)"
    '
  )

  hyprctl eval "
    hl.window_rule({
      name = 'flameshot',
      match = {
        initial_title = 'flameshot'
      },
      monitor = '$monitor',
      move = '$move_x $move_y',
      size = '$width $height',
      pin = true,
      float = true,
      rounding = 0,
      border_size = 0,
      stay_focused = true,
      suppress_event = 'fullscreen'
    })
  "
fi

flameshot "$@"
