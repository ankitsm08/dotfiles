-- Normal mode
local opts = { noremap = true, silent = true }

local directions = {
  h = "<Left>",
  j = "<Down>",
  k = "<Up>",
  l = "<Right>",
}

for key, arrow in pairs(directions) do
  vim.keymap.set("n", "<C-" .. key .. ">", "<C-w>" .. key, opts)
  vim.keymap.set("n", "<C-" .. arrow .. ">", "<C-w>" .. key, opts)
end

vim.keymap.set({ "n", "v" }, "H", "^", opts)
vim.keymap.set({ "n", "v" }, "L", "$", opts)
vim.keymap.set({ "n", "v" }, "M", "%", opts)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    for key, arrow in pairs(directions) do
      vim.keymap.set("n", "<C-" .. key .. ">", "<C-w>" .. key, opts)
      vim.keymap.set("n", "<C-" .. arrow .. ">", "<C-w>" .. key, opts)
    end
  end,
})
