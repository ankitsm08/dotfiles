-- Voxtype compositor integration
-- Fixes modifier key interference when using compositor keybindings
--
-- Two submaps are used:
-- - voxtype_recording: Active during recording/transcription. F12 cancels.
-- - voxtype_suppress: Active during text output. Blocks modifier keys.
--
-- NOTE: Do not bind Escape in voxtype_suppress. Binding Escape causes wtype's
-- first character to be dropped. See: https://github.com/hyprwm/Hyprland/issues/3165

-- Recording submap - active during recording and transcription
-- F12 cancels recording/transcription and returns to normal
hl.define_submap("voxtype_recording", function()
  hl.bind("F12", hl.dsp.exec_cmd("voxtype record cancel"))
  hl.bind("F12", hl.dsp.submap("reset"))
end)

-- Output submap - blocks modifier keys during text output
hl.define_submap("voxtype_suppress", function()
  hl.bind("SUPER_L", function()
    return true
  end)
  hl.bind("SUPER_R", function()
    return true
  end)
  hl.bind("Control_L", function()
    return true
  end)
  hl.bind("Control_R", function()
    return true
  end)
  hl.bind("Alt_L", function()
    return true
  end)
  hl.bind("Alt_L", function()
    return true
  end)
  hl.bind("Shift_L", function()
    return true
  end)
  hl.bind("Shift_L", function()
    return true
  end)
  hl.bind("F12", hl.dsp.submap("reset"))
end)
