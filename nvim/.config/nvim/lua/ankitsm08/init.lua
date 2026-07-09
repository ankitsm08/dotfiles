require("ankitsm08.navigation")
require("ankitsm08.tmux")

vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights", silent = true })

-- vim.keymap.set("i", "jk", "<esc>", { desc = "Escape", silent = true })
-- vim.keymap.set("i", "kj", "<esc>", { desc = "Escape", silent = true })

vim.keymap.set("n", "_", "<C-x>", { desc = "Decrement", silent = true, noremap = true })
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", silent = true, noremap = true })

vim.api.nvim_create_user_command("Wnf", function()
  vim.cmd("noautocmd write")
end, {})

vim.keymap.set("x", "<leader>p", function()
  local col = vim.fn.col("'>")
  local line = vim.fn.getline("'>")
  return (col >= #line) and '"_dp' or '"_dP'
end, {
  expr = true,
  desc = "Paste without yank",
  silent = true,
})

vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change without yank", silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank", silent = true })

-- vim.keymap.set(')
