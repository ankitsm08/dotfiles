-- Default Monitor Setup
hl.monitor({
  output = "desc:AU Optronics 0x369F",
  mode = "1920x1080@60.04",
  position = "2560x0",
  scale = 1,
  vrr = 1,
  sdr_min_luminance = 0.2,
  sdr_max_luminance = 80,
})
hl.monitor({
  output = "desc:LG Electronics LG IPS QHD 406NTAB1G616",
  mode = "2560x1440@74.96",
  position = "0x0",
  scale = 1,
  vrr = 1,
  sdr_min_luminance = 0.2,
  sdr_max_luminance = 80,
})

-- External monitor (preferred)
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", layout = "master", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", layout = "dwindle", default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1", layout = "dwindle", default = true, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", layout = "dwindle", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", layout = "scrolling", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", layout = "dwindle", persistent = true })

-- Laptop panel
hl.workspace_rule({ workspace = "7", monitor = "eDP-1", layout = "master", default = true, persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1", layout = "scrolling", persistent = true })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1", layout = "scrolling", persistent = true })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1", layout = "master", persistent = true })
