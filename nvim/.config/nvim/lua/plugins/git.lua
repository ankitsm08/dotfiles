return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    keys = {
      {
        "<leader>gb",
        function()
          require("gitsigns").blame_line()
        end,
        desc = "Toggle current line blame",
      },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "esmuellert/codediff.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>ggn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
  {
    "YouSame2/inlinediff-nvim",
    lazy = true,
    cmd = "InlineDiff",
    opts = {},
    keys = {
      {
        "<leader>gd",
        function()
          require("inlinediff").toggle()
        end,
        desc = "Toggle inline diff",
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>ggl", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
    },
  },
}
