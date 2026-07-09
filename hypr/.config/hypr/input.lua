-- INPUT

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:hyper, shift:both_capslock, compose:prsc",
    kb_rules = "",

    numlock_by_default = true,

    repeat_rate = 30,
    repeat_delay = 200,

    follow_mouse = 2,

    float_switch_override_focus = false,
    sensitivity = 0,
    accel_profile = "flat",

    touchpad = {
      disable_while_typing = true,
      natural_scroll = false,
      scroll_factor = 0.2,

      clickfinger_behavior = true,
      tap_to_click = true,
      tap_and_drag = true,
      drag_lock = 2,
    },
  },
})

hl.config({
  gestures = {
    workspace_swipe_invert = false,
  },
})

hl.gesture({
  fingers = 3,
  direction = "left",
  action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "-1" }))
  end,
})
hl.gesture({
  fingers = 3,
  direction = "right",
  action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "+1" }))
  end,
})
hl.gesture({
  fingers = 3,
  direction = "down",
  action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
  end,
})
hl.gesture({
  fingers = 3,
  direction = "up",
  action = "special",
  workspace_name = "magic",
})
hl.gesture({
  fingers = 4,
  direction = "pinch",
  action = "cursorZoom",
  zoom_level = 1,
  mode = "live",
})
hl.gesture({
  fingers = 4,
  direction = "down",
  action = "float",
})
hl.gesture({
  fingers = 4,
  direction = "up",
  action = "fullscreen",
})
