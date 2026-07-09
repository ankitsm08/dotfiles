vim.keymap.set(
  "n",
  "<C-f>",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { noremap = true, desc = "Open tmux sessionizer" }
)
