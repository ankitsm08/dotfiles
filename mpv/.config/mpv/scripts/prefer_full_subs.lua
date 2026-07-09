local mp = require("mp")

local function norm(s)
  return (s or ""):lower()
end

local function is_english(lang)
  lang = norm(lang)
  return lang == "en" or lang == "eng" or lang:match("^en[%-%s%-_]")
end

local function score_sub(t)
  if t.type ~= "sub" then
    return -1
  end

  local lang = norm(t.lang)
  local title = norm(t.title)

  if not is_english(lang) then
    return -1
  end

  local score = 100

  if title:find("full", 1, true) then
    score = score + 1000
  end

  if title:find("sign", 1, true) or title:find("song", 1, true) then
    score = score - 200
  end

  if t.forced then
    score = score - 50
  end

  if t.default then
    score = score + 10
  end

  return score
end

mp.register_event("file-loaded", function()
  local tracks = mp.get_property_native("track-list") or {}
  local best_id = nil
  local best_score = -1

  for _, t in ipairs(tracks) do
    local s = score_sub(t)
    if s > best_score then
      best_score = s
      best_id = t.id
    end
  end

  if best_id then
    mp.set_property_number("sid", best_id)
  end
end)
