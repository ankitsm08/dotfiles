-- AUTOSTART

local vars = require("variables")

hl.on("hyprland.start", function()
  -- Environment
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("waybar")
  -- hl.exec_cmd("hyprmoncfgd")
  hl.exec_cmd("voxtype daemon")
  hl.exec_cmd("swaync")
  hl.exec_cmd("playerctld daemon")
  hl.exec_cmd("swayosd-server")
  hl.exec_cmd("vicinae server")
  hl.exec_cmd("udiskie -t")
  hl.exec_cmd("wayscriber --daemon")

  -- Slow app launch fix -- set systemd vars
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")

  -- Custom services
  hl.exec_cmd("syncthing serve --no-browser")
  hl.exec_cmd("gotify-desktop")
  hl.exec_cmd("tailscale systray")
  hl.exec_cmd("~/.config/hypr/scripts/soundboard-setup.sh")

  -- Start recording clipboard history (text + images)
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-clip-persist --clipboard regular")

  -- Set primary monitor
  -- if HDMI-A-1 exists
  if hl.get_monitor("HDMI-A-1") then
    hl.exec_cmd("xrandr --output HDMI-A-1 --primary")
  end

  -- Launch apps
  hl.timer(function()
    hl.exec_cmd(vars.browser, { workspace = "1" })
    hl.exec_cmd(vars.terminalNew .. ' -e zsh -c "tmux-sessionizer ~; exec zsh"', { workspace = "2" })
    hl.dispatch(hl.dsp.focus({ workspace = "1" }))
  end, { timeout = 100, type = "oneshot" })
end)
