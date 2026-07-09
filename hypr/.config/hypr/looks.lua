-- LOOK AND FEEL

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = { top = 5, left = 7, right = 7, bottom = 5 },
    float_gaps = 28,

    border_size = 1,

    col = {
      active_border = { colors = { "rgba(7090ffaa)", "rgba(564cabaa)" }, angle = 45 },
      inactive_border = "rgba(505060aa)",
    },

    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true,

    allow_tearing = false,
    layout = "dwindle",
  },
})

hl.config({
  decoration = {
    rounding = 6,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    -- active_opacity = 0.98, -- default: 1
    -- inactive_opacity = 0.94, -- default: 1

    shadow = {
      enabled = false, -- default: true
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    blur = {
      enabled = false, -- default: true
      size = 2,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
})

hl.config({
  animations = {
    enabled = true,
    workspace_wraparound = true,
  },
})

hl.curve("easeOutQuint", {
  type = "bezier",
  points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
  type = "bezier",
  points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", {
  type = "bezier",
  points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("almostLinear", {
  type = "bezier",
  points = { { 0.5, 0.5 }, { 0.75, 1 } },
})
hl.curve("quick", {
  type = "bezier",
  points = { { 0.15, 0 }, { 0.1, 1 } },
})
hl.curve("slow", {
  type = "bezier",
  points = { { 1.00, 0 }, { 1, 1 } },
})

hl.curve("easy", {
  type = "spring",
  mass = 1,
  stiffness = 71.2633,
  dampening = 15.8273644,
})

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 1.4, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.8, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fade", enabled = true, speed = 4.1, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.75, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.55, bezier = "almostLinear" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.8, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.2, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.2, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.4, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 0.4, bezier = "linear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.4, bezier = "slow", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
hl.animation({ leaf = "monitorAdded", enabled = true, speed = 7, bezier = "quick" })

hl.config({
  group = {
    col = {
      border_active = { colors = { "rgba(7287fdaa)", "rgba(8839efaa)" }, angle = 45 },
      border_inactive = "rgba(595959aa)",
      border_locked_active = "rgba(797979aa)",
      border_locked_inactive = "rgba(79797988)",
    },

    groupbar = {
      font_size = 12,
      font_family = "JetBrainsMono Nerd Font",
      font_weight_active = "ultraheavy",
      font_weight_inactive = "normal",

      indicator_height = 0,
      indicator_gap = 5,
      height = 22,
      gaps_in = 5,
      gaps_out = 0,

      text_color = "rgb(ffffff)",
      text_color_inactive = "rgba(ffffff90)",
      col = {
        active = "rgba(00000040)",
        inactive = "rgba(00000020)",
      },

      gradients = true,
      gradient_rounding = 0,
      gradient_round_only_edges = false,
    },
  },
})

hl.config({
  cursor = {
    hide_on_key_press = true,
    persistent_warps = true,
    warp_back_after_non_mouse_input = true,
  },
})

hl.config({
  misc = {
    key_press_enables_dpms = false, -- key press will not trigger wake
    mouse_move_enables_dpms = false, -- mouse move will not trigger wake
    force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    mouse_move_focuses_monitor = false,
    disable_splash_rendering = true,
    anr_missed_pings = 3,
    on_focus_under_fullscreen = 1,
    initial_workspace_tracking = 1, -- 0 - disabled, 1 - single-shot, 2 - persistent (all children too)
    layers_hog_keyboard_focus = true,
    vrr = true,
  },
})

-- Style Gum confirm to match terminal theme
hl.env("GUM_CONFIRM_PROMPT_FOREGROUND", "6") -- Cyan
hl.env("GUM_CONFIRM_SELECTED_FOREGROUND", "0") -- Black
hl.env("GUM_CONFIRM_SELECTED_BACKGROUND", "2") -- Green
hl.env("GUM_CONFIRM_UNSELECTED_FOREGROUND", "0") -- Black
hl.env("GUM_CONFIRM_UNSELECTED_BACKGROUND", "8") -- Dark grey
