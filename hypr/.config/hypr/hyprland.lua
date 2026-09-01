-- HYPRLAND CONFIG

-- Environment Vars
require("env")

-- Core behavior
require("input")
require("looks")
require("rules")

-- Keybindings
require("keybinds")

-- Other configs
require("conf")

-- Display
require("workspaces")

-- Autostart
require("autostart")

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
dofile((os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/hypr/hyprmoncfg-monitors.lua")
