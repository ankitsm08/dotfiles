local mp = require("mp")

local enabled = false

local function apply(on)
  mp.set_property_number("contrast", on and 6 or 0)
  mp.set_property_number("brightness", on and -1 or 0)
  mp.set_property_number("gamma", on and 2 or 0)
  mp.set_property_number("saturation", on and 10 or 0)
end

mp.add_key_binding("Alt+p", "toggle-punchy", function()
  enabled = not enabled
  apply(enabled)
end)
