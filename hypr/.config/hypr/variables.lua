local M = {}

-- Programs
M.floatingTerminal = "foot --app-id=TUI.float"
M.terminal = "ghostty +new-window"
M.terminalNew = "ghostty"

local function floatTerm(program)
  return M.floatingTerminal .. " -e " .. program
end

M.terminalFileManager = floatTerm("yazi")
M.taskManager = floatTerm("btop")
M.aiChatInterface = floatTerm("aichat")
M.audioInterface = floatTerm("wiremix")
M.networkInterface = floatTerm("impala")
M.bluetoothInterface = floatTerm("bluetui")

M.fileManager = "thunar"

M.browser = "zen-browser"
M.browserAlt = "brave"

M.mediaPlayer = "mpv"

M.menu = "rofi"
M.menuApps = M.menu .. " -show drun || pkill " .. M.menu
M.menuCommand = M.menu .. " -show run || pkill " .. M.menu
M.menuWindow = M.menu .. " -show window || pkill " .. M.menu
M.menuClip = "cliphist list | ("
  .. M.menu
  .. " -dmenu -display-columns 2 || pkill "
  .. M.menu
  .. ") | cliphist decode | wl-copy"
M.menuCalc = M.menu
  .. " -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\" || pkill "
  .. M.menu

M.slurp_cmd = "slurp -b 00000060 -c b4befe -w 1 -d "

M.focused_monitor = "\"$(hyprctl -j monitors | jq -r '.[] | select(.focused).name')\""
return M
