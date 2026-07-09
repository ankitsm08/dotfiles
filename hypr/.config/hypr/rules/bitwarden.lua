-- Bitwarden rules
hl.window_rule({
  match = {
    class = [[^(Bitwarden)$]],
  },
  no_screen_share = true,
  tag = "+floating-window",
})
