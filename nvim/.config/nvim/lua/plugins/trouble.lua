return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>xt", "<cmd>Trouble toggle<cr>", desc = "[X] [T]rouble" },
      { "<leader>xT", "<cmd>Trouble diagnostics toggle<cr>", desc = "[X] Workspace [D]iagnostics" },
    },
    opts = {},
  },
}
