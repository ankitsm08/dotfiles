local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Quickfix / location list navigation
map("n", "]q", function()
  if vim.fn.getqflist({ winid = 0 }).winid == 0 then
    vim.cmd("copen")
  end
  vim.cmd("cnext")
end, { desc = "Quickfix next" })
map("n", "[q", function()
  if vim.fn.getqflist({ winid = 0 }).winid == 0 then
    vim.cmd("copen")
  end
  vim.cmd("cprev")
end, { desc = "Quickfix prev" })
map("n", "]j", function()
  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.notify("No location list", vim.log.levels.WARN)
    return
  end
  vim.cmd("lnext")
end, { desc = "Location next" })
map("n", "[j", function()
  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.notify("No location list", vim.log.levels.WARN)
    return
  end
  vim.cmd("lprev")
end, { desc = "Location prev" })
map("n", "<leader>xq", function()
  vim.cmd("copen")
end, { desc = "[X] Open [Q]uickfix" })
map("n", "<leader>xl", function()
  vim.cmd("lopen")
end, { desc = "[X] Open [L]ocation" })

-- Clear search highlights
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights", silent = true })

-- UI toggles
map("n", "<leader>tn", function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = vim.o.number
  vim.notify("Line numbers: " .. (vim.o.number and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[T]oggle [N]umbers" })

map("n", "<leader>ts", function()
  vim.o.spell = not vim.o.spell
  vim.notify("Spell check: " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[T]oggle [S]pell" })

map("n", "<leader>tw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Wrap: " .. (vim.o.wrap and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[T]oggle [W]rap" })

map("n", "<leader>tl", function()
  vim.o.list = not vim.o.list
  vim.notify("List chars: " .. (vim.o.list and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[T]oggle [L]ist chars" })

map("n", "<leader>tu", function()
  vim.o.cursorline = not vim.o.cursorline
  vim.notify("Cursorline: " .. (vim.o.cursorline and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[T]oggle c[U]rsorline" })

map("n", "<leader>tb", function()
  if vim.go.background == "dark" then
    vim.go.background = "light"
  else
    vim.go.background = "dark"
  end
  vim.notify("Background: " .. vim.go.background, vim.log.levels.INFO)
end, { desc = "[T]oggle [B]ackground" })
