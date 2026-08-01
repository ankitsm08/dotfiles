-- KEYBINDINGS

local vars = require("variables")

local super = "SUPER + "
local control = "CTRL + "
local alter = "ALT + "
local shift = "SHIFT + "
local special = "MOD3 + "

hl.bind(special .. "Q", function()
  hl.timer(function()
    hl.dispatch(hl.dsp.dpms({ action = hl.get_active_monitor().dpms_status and "disable" or "enable" }))
  end, { timeout = 30, type = "oneshot" })
end, { locked = true })

-- Privacy
hl.bind(
  super .. "M",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { repeating = true, locked = true }
)

-- Lock screen
hl.bind(super .. control .. shift .. "L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(super .. control .. "L", hl.dsp.exec_cmd("pkill wlogout || wlogout"))

-- Wallpaper picker/changer
hl.bind(
  super .. "W",
  hl.dsp.exec_cmd("vicinae vicinae://launch/@sovereign/store.vicinae.awww-switcher/wpgrid"),
  { description = "Pick a wallpaper" }
)
hl.bind(
  super .. shift .. "W",
  hl.dsp.exec_cmd("vicinae vicinae://launch/@sovereign/store.vicinae.awww-switcher/wprandom"),
  { description = "Pick a wallpaper" }
)
hl.bind(
  super .. alter .. "W",
  hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh --random"),
  { description = "Random wallpaper" }
)
hl.bind(
  super .. alter .. shift .. "W",
  hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh --reverse"),
  { description = "Reverse wallpaper" }
)

-- Launcher
hl.bind(super .. "Space", hl.dsp.exec_cmd("vicinae toggle"), { description = "Toggle Vicinae" })
hl.bind(super .. control .. "SPACE", hl.dsp.exec_cmd(vars.menuApps), { description = "Applications" })

-- Calculator
hl.bind(super .. alter .. "C", hl.dsp.exec_cmd(vars.menuCalc), { description = "Calculator" })

-- Clipboard History
hl.bind(
  super .. "V",
  hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"),
  { description = "Access Clipboard History" }
)
hl.bind(super .. shift .. "V", hl.dsp.exec_cmd(vars.menuClip), { description = "Access Clipboard History (Rofi)" })

-- Colorpicker
hl.bind(super .. shift .. "C", hl.dsp.exec_cmd("hyprpicker -a -u 160 -s 2 -t -l"), { description = "Color Picker" })

-- Dictation
hl.bind(super .. shift .. "X", hl.dsp.exec_cmd("voxtype record toggle"), { description = "Toggle dictation" })
hl.bind(super .. control .. "X", hl.dsp.exec_cmd("voxtype record cancel"), { description = "Cancel dictation" })

-- Dictionary
hl.bind(
  super .. shift .. "D",
  hl.dsp.exec_cmd("GRAB=1 ~/.config/hypr/scripts/define.sh"),
  { description = "Define Selected Word" }
)
hl.bind(
  super .. control .. "D",
  hl.dsp.exec_cmd("~/.config/hypr/scripts/define.sh"),
  { description = "Define Word in Clipboard" }
)

-- Soundboard
hl.bind(
  super .. "S",
  hl.dsp.exec_cmd(vars.floatingTerminal .. " -e ~/.config/hypr/scripts/soundboard.sh"),
  { description = "Soundboard" }
)

-- Screenshot
hl.bind(
  super .. shift .. "S",
  hl.dsp.exec_cmd(
    "grim -s 1 -o \"$(hyprctl -j monitors | jq -r '.[] | select(.focused).name')\" - | satty --disable-notifications -f -"
  ),
  { description = "Active Monitor Screenshot" }
)
hl.bind(
  super .. control .. "S",
  hl.dsp.exec_cmd('grim -s 1 -g "$(' .. vars.slurp_cmd .. ')" - | satty --disable-notifications -f -'),
  { description = "Region Select Screenshot" }
)

-- OCR
hl.bind(
  super .. shift .. "T",
  hl.dsp.exec_cmd("~/.config/hypr/scripts/ocr.sh"),
  { description = "Optical Character Recognition" }
)

-- QR & Barcodes
hl.bind(super .. shift .. "Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/qr.sh"), { description = "Scan QR & Barcodes" })

-- Screen Annotation
hl.bind(super .. "A", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscribe"), { description = "Toggle Screen Annotation" })

-- Screen Recording
hl.bind(super .. "R", hl.dsp.exec_cmd("~/.local/bin/screenrec toggle"), { description = "Toggle Screen Recording" })
hl.bind(
  super .. shift .. "R",
  hl.dsp.exec_cmd("~/.local/bin/screenrec toggle --audio"),
  { description = "Toggle Screen Recording with Mic Audio" }
)
hl.bind(
  super .. alter .. "R",
  hl.dsp.exec_cmd("~/.local/bin/screenrec toggle --audio-device"),
  { description = "Toggle Screen Recording with Device Audio" }
)

-- ==========================================================
-- Mouse bindings
-- ==========================================================

-- Bind 4th mouse button to middle mouse since its more comfortable
hl.bind("mouse:275", function()
  hl.timer(function()
    hl.dispatch(hl.dsp.send_shortcut({ mods = "", key = "mouse:274" }))
  end, { timeout = 1, type = "oneshot" })
end, { submap_universal = true })

-- Bind 5th mouse button to open multi-layer submap for mouse actions
hl.bind("mouse:276", hl.dsp.submap("double-click-submap"), { release = true })

-- Submaps nicely scope logic in Lua configurations, so you don't need `submap = reset` later.
hl.define_submap("double-click-submap", function()
  hl.bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
  hl.bind("mouse:272", hl.dsp.window.float({ action = "toggle" }), { click = true })
  hl.bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

  -- hl.bind("mouse:275", hl.dsp.window.close(), { click = true })
  hl.bind("mouse:274", hl.dsp.window.close(), { click = true })

  -- hl.define_submap("triple-click-submap", function() ... end)

  hl.bind("mouse:276", hl.dsp.submap("reset"), { release = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ==========================================================
-- Special to Control maps
-- ==========================================================
local specialControlKeys =
  { "A", "B", "C", "D", "E", "F", "G", "N", "P", "R", "T", "U", "V", "W", "X", "Y", "Z", "SPACE", "TAB" }
for _, key in ipairs(specialControlKeys) do
  hl.bind(special .. key, function()
    hl.timer(function()
      hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL", key = key:upper() }))
    end, { timeout = 1, type = "oneshot" })
  end, { submap_universal = true, repeating = true, transparent = true })
end

-- Special QOF arrow binds
local directions = { h = "LEFT", j = "DOWN", k = "UP", l = "RIGHT" }
for key, dir in pairs(directions) do
  hl.bind(special .. key, function()
    hl.timer(function()
      hl.dispatch(hl.dsp.send_shortcut({ mods = "", key = dir }))
    end, { timeout = 1, type = "oneshot" })
  end, { submap_universal = true, repeating = true, transparent = true })
  hl.bind(special .. shift .. key, function()
    hl.timer(function()
      hl.dispatch(hl.dsp.send_shortcut({ mods = "SHIFT", key = dir }))
    end, { timeout = 1, type = "oneshot" })
  end, { submap_universal = true, repeating = true, transparent = true })
  hl.bind(special .. alter .. key, function()
    hl.timer(function()
      hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL", key = dir }))
    end, { timeout = 1, type = "oneshot" })
  end, { submap_universal = true, repeating = true, transparent = true })
  hl.bind(special .. alter .. shift .. key, function()
    hl.timer(function()
      hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = dir }))
    end, { timeout = 1, type = "oneshot" })
  end, { submap_universal = true, repeating = true, transparent = true })
end

-- ==========================================================
-- General Bindings
-- ==========================================================
hl.bind(super .. "Q", hl.dsp.exec_cmd(vars.terminal))
hl.bind(super .. shift .. "M", hl.dsp.exec_cmd(vars.mediaPlayer .. " --player-operation-mode=pseudo-gui"))
hl.bind(super .. shift .. "B", hl.dsp.exec_cmd(vars.browser))
hl.bind(super .. alter .. "B", hl.dsp.exec_cmd(vars.browserAlt))
hl.bind(super .. "C", hl.dsp.window.close())
hl.bind(super .. control .. "C", hl.dsp.window.kill())

-- Programs
hl.bind(super .. "E", hl.dsp.exec_cmd(vars.terminalFileManager))
hl.bind(super .. alter .. "M", hl.dsp.exec_cmd(vars.audioInterface))
hl.bind(super .. shift .. "return", hl.dsp.exec_cmd(vars.aiChatInterface))
hl.bind(super .. "N", hl.dsp.exec_cmd(vars.networkInterface))
hl.bind(super .. "B", hl.dsp.exec_cmd(vars.bluetoothInterface))
hl.bind(control .. shift .. "escape", hl.dsp.exec_cmd(vars.taskManager))

hl.bind(super .. shift .. "E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(super .. "X", hl.dsp.window.center())
hl.bind(super .. shift .. "F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(super .. alter .. "F", hl.dsp.exec_cmd("~/.config/hypr/scripts/hypr-float-toggle.sh"))
hl.bind(super .. "F", hl.dsp.window.fullscreen())
hl.bind(super .. alter .. "P", hl.dsp.window.pin())
hl.bind(super .. "G", hl.dsp.layout("togglesplit"))

hl.bind(super .. shift .. "ESCAPE", hl.dsp.exec_cmd("~/.config/hypr/scripts/waybar-toggle.sh"))
hl.bind(super .. control .. "ESCAPE", hl.dsp.exec_cmd("hyprctl reload"))

-- Move focus with super + hjkl
hl.bind(super .. "h", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(super .. "l", hl.dsp.focus({ direction = "r" }), { repeating = true })
hl.bind(super .. "k", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(super .. "j", hl.dsp.focus({ direction = "d" }), { repeating = true })

-- Tab cycling focus
hl.bind(alter .. "TAB", hl.dsp.window.cycle_next(), { repeating = true })
hl.bind(alter .. "TAB", hl.dsp.window.alter_zorder({ mode = "top" }), { repeating = true })
hl.bind(alter .. shift .. "TAB", hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind(alter .. shift .. "TAB", hl.dsp.window.alter_zorder({ mode = "top" }), { repeating = true })

-- Move active window with super + hjkl
hl.bind(super .. shift .. "h", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(super .. shift .. "l", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(super .. shift .. "k", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(super .. shift .. "j", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Active floating window move mode with super + control + M
hl.bind(super .. control .. "M", hl.dsp.submap("floatmove"))

hl.define_submap("floatmove", function()
  hl.bind("h", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })

  hl.bind("SHIFT + h", hl.dsp.window.move({ x = -100, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + l", hl.dsp.window.move({ x = 100, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + k", hl.dsp.window.move({ x = 0, y = -100, relative = true }), { repeating = true })
  hl.bind("SHIFT + j", hl.dsp.window.move({ x = 0, y = 100, relative = true }), { repeating = true })

  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Resize windows with super + uiop
hl.bind(super .. "u", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(super .. "p", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(super .. "o", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(super .. "i", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

-- Toggle resize mode with super + control + R
hl.bind(super .. control .. "R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind("h", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

  hl.bind("SHIFT + h", hl.dsp.window.resize({ x = -160, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + l", hl.dsp.window.resize({ x = 160, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -160, relative = true }), { repeating = true })
  hl.bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 160, relative = true }), { repeating = true })

  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ==========================================================
-- Workspaces
-- ==========================================================
-- Switch workspaces with super + [0-9] and Move active window
-- We can simplify this heavily in Lua with a loop
for i = 1, 9 do
  hl.bind(super .. tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
  hl.bind(super .. shift .. tostring(i), hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end
hl.bind(super .. "0", hl.dsp.focus({ workspace = "10" }))
hl.bind(super .. shift .. "0", hl.dsp.window.move({ workspace = "10", follow = false }))

-- Switch workspaces with super + special keys
hl.bind(super .. "TAB", hl.dsp.focus({ workspace = "previous" }))

-- Workspace mode with super + control + W
hl.bind(super .. control .. "W", hl.dsp.submap("workspace"))

hl.define_submap("workspace", function()
  hl.bind("h", hl.dsp.focus({ workspace = "e-1" }))
  hl.bind("l", hl.dsp.focus({ workspace = "e+1" }))
  hl.bind("j", hl.dsp.focus({ workspace = "previous" }))
  hl.bind("k", hl.dsp.focus({ workspace = "empty" }))

  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Pause all keybinds until pressed again
hl.bind(super .. control .. "P", hl.dsp.submap("pause"))

hl.define_submap("pause", function()
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- -- Move active workspace with super + alternate + asdf
-- hl.bind(super .. shift .. "u", hl.dsp.workspace.move({ monitor = "l" }))
-- hl.bind(super .. shift .. "i", hl.dsp.workspace.move({ monitor = "d" }))
-- hl.bind(super .. shift .. "o", hl.dsp.workspace.move({ monitor = "u" }))
-- hl.bind(super .. shift .. "p", hl.dsp.workspace.move({ monitor = "r" }))

-- Special workspace (scratchpad) using '`'
hl.bind(super .. "code:49", function()
  local active_special = hl.get_active_special_workspace()
  if active_special and active_special.name == "special:magic" then
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  end
end)
hl.bind(super .. alter .. "code:49", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. control .. "code:49", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. "backslash", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. shift .. "code:49", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Scroll through existing workspaces with super + scroll
hl.bind(super .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ==========================================================
-- Mouse Binds Core Configuration
-- ==========================================================
-- Fire a drag event only after dragging for more than 10px
hl.config({
  binds = {
    drag_threshold = 4,
  },
})

hl.bind(super .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(super .. "mouse:272", hl.dsp.window.float({ action = "toggle" }), { click = true })
hl.bind(super .. "mouse:273", hl.dsp.window.resize(), { mouse = true }) -- change aspect ratio
hl.bind(super .. "mouse:274", hl.dsp.window.close(), { mouse = true }) -- change aspect ratio

-- ==========================================================
-- Notifications, Media & Control keys
-- ==========================================================
hl.bind(super .. "N", hl.dsp.exec_cmd("swaync-client --close-latest"), { description = "Close Latest Notification" })
hl.bind(
  super .. control .. "N",
  hl.dsp.exec_cmd("swaync-client --toggle-panel"),
  { description = "Toggle Notification Panel" }
)
hl.bind(super .. shift .. "N", hl.dsp.exec_cmd("swaync-client --toggle-dnd"), { description = "Toggle Do Not Disturb" })

-- Num Lock is always ON and Scroll Lock is always OFF and Caps Lock is non-existent
-- hl.bind("Num_Lock", hl.dsp.exec_cmd("swayosd-client --monitor \"$(hyprctl -j monitors | jq -r '.[] | select(.focused).name')\" --num-lock"), { repeating = true, locked = true })
-- hl.bind("Scroll_Lock", hl.dsp.exec_cmd("swayosd-client --monitor \"$(hyprctl -j monitors | jq -r '.[] | select(.focused).name')\" --scroll-lock"), { repeating = true, locked = true })

-- Power Button
hl.bind("XF86PowerOff", function()
  hl.dispatch(hl.dsp.exec_cmd("pkill wlogout || wlogout"))
end, { repeating = false, locked = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", function()
  hl.dispatch(hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --output-volume raise"))
end, { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", function()
  hl.dispatch(hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --output-volume lower"))
end, { repeating = true, locked = true })
hl.bind("XF86AudioMute", function()
  hl.dispatch(
    hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --output-volume mute-toggle")
  )
end, { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", function()
  hl.dispatch(
    hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --input-volume mute-toggle")
  )
end, { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", function()
  hl.dispatch(hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --brightness raise"))
end, { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", function()
  hl.dispatch(hl.dsp.exec_cmd("swayosd-client --monitor " .. hl.get_active_monitor().name .. " --brightness lower"))
end, { repeating = true, locked = true })

-- Requires mediactl or playerctl
hl.bind(super .. shift .. "P", hl.dsp.exec_cmd("mediactl toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mediactl toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("mediactl toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("mediactl next"), { repeating = true, locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("mediactl prev"), { repeating = true, locked = true })

-- ==========================================================
-- Glass Magnifier
-- ==========================================================
local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
  local current = hl.get_config("cursor.zoom_factor")
  if offset ~= nil then
    current = current + offset
  elseif current ~= MIN_ZOOM then
    if current == ZOOM_TOGGLE_FACTOR then
      current = MAX_ZOOM
    else
      current = MIN_ZOOM
    end
  else
    current = ZOOM_TOGGLE_FACTOR
  end
  current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
  hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + equal", function()
  zoom(0.5)
end)
hl.bind("SUPER + minus", function()
  zoom(-0.5)
end)
