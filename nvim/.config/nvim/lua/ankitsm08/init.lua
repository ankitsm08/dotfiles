require("ankitsm08.navigation")
require("ankitsm08.tmux")
require("ankitsm08.keymaps")

vim.api.nvim_create_user_command("Wnf", function()
  vim.cmd("noautocmd write")
end, {})

vim.keymap.set("x", "<leader>p", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"_c<C-r>"<Esc>', true, false, true), "n", true)
end, { desc = "Paste without yank", silent = true })

vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change without yank", silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank", silent = true })
