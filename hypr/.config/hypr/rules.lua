-- WINDOWS AND WORKSPACES

hl.config({
  dwindle = {
    preserve_split = true, -- the split (side/top) will not change regardless of what happens to the container
    force_split = 2, -- Always split on the right or bottom
  },

  master = {
    mfact = 0.65,
    new_status = "slave",
  },

  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.9,
  },

  monocle = {},
})

-- Ignore maximize requests from all apps.
hl.window_rule({
  name = "suppress-maximize-events",
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = { 20, "monitor_h - 120" },
  float = true,
})

-- Fix pinentry losing focus
hl.window_rule({
  match = { class = "(pinentry-)(.*)" },
  stay_focused = true,
})

-- App Specific rules
require("rules.init")
