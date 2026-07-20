return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      {
        "<leader>qS",
        function()
          require("persistence").save()
        end,
        desc = "[Q]uit [S]ave session",
      },
      {
        "<leader>qL",
        function()
          require("persistence").load()
        end,
        desc = "[Q]uit [L]oad session",
      },
    },
  },
}
