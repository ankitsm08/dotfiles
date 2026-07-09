-- Floating windows (tag-driven)
-- You can now combine multiple effects targeting the same tag into one block!
hl.window_rule({
  match = { tag = "floating-window" },
  float = true,
  center = true,
  size = { 1600, 900 },
})

hl.window_rule({
  match = {
    class = [[(org\.gnome\.NautilusPreviewer|org\.gnome\.Evince|com\.gabm\.satty|imv|mpv|About|TUI\.float|yad)]],
  },
  tag = "+floating-window",
})

hl.window_rule({
  match = {
    class = [[hyprland-share-picker]],
    title = [[^([Ss]elect what to share.*)$]],
  },
  tag = "+floating-window",
})

hl.window_rule({
  match = {
    class = [[(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org\.gnome\.Nautilus)$]],
    title = [[^(File.*Upload|Open.*Files|Open.*[Ff]older|Save.*Files|Save.*As|Save|All.*Files|.*wants to (open|save).*|[Cc]hoose.*).*$]],
  },
  tag = "+floating-window",
})

hl.window_rule({
  match = {
    class = [[(org\.pulseaudio\.pavucontrol|org\.pipewire\.Helvum|blueman-manager|nm-connection-editor)$]],
  },
  tag = "+floating-window",
})

hl.window_rule({
  match = {
    class = [[^org\.gnome\.Calculator$]],
  },
  float = true,
})

-- No transparency on media / capture windows
hl.window_rule({
  match = {
    class = [[(zoom|vlc|mpv|org\.kde\.kdenlive|com\.obsproject\.Studio|com\.github\.PintaProject\.Pinta|imv|org\.gnome\.NautilusPreviewer)]],
  },
  -- Hyprland opacity accepts standard values "active inactive". Adding "override" ensures
  -- that these values won't be overridden by general workspace transparency rules.
  opacity = "1.0 override 1.0 override",
})
