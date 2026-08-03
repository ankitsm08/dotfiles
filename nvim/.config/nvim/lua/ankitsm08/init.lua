require("ankitsm08.navigation")
require("ankitsm08.tmux")
require("ankitsm08.keymaps")

vim.api.nvim_create_user_command("Wnf", function()
  vim.cmd("noautocmd write")
end, {})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Paste without yank: p replaces selection, gv reselects, y restores register.
-- Clipboard is detached during the op so nothing syncs to the OS clipboard.
map("x", "<leader>p", function()
  local cb = vim.o.clipboard
  vim.o.clipboard = ""
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("pgvy", true, false, true), "xn", false)
  vim.o.clipboard = cb
end, { desc = "Paste without yank" })

-- Change / delete without yank: "_ sends text to black hole,
-- c / d stay operator-pending in normal mode
map({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change without yank" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Whole buffer operations
map("n", "<leader>P", function()
  if vim.fn.getreg('"') == "" then
    vim.notify("Register is empty", vim.log.levels.WARN)
    return
  end
  vim.cmd("silent %d _")
  vim.cmd("silent put!")
  vim.cmd("silent $d _")
  vim.cmd("normal! gg")
end, { desc = "Paste over whole buffer" })
map("n", "yY", function()
  vim.cmd("silent %y")
end, { desc = "Yank whole buffer" })
map("n", "dD", function()
  vim.cmd("silent %d _")
end, { desc = "Delete whole buffer" })

-- Clear search highlights
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights", silent = true })
