return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree", -- load on first use
    keys = {
      {
        "<leader>en",
        "<cmd>Neotree toggle<cr>",
        desc = "NeoTree [T]oggle",
      },
      {
        "<leader>er",
        "<cmd>Neotree reveal<cr>",
        desc = "NeoTree [R]eveal File",
      },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        hijack_netrw_behavior = "disabled",
        follow_current_file = {
          enabled = true,
        },
      },
    },
  },
}
