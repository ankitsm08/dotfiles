return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        "blank",
        "buffers",
        "curdir",
        "folds",
        "help",
        "tabpages",
        "winsize",
        "winpos",
        "terminal",
        "localoptions",
      },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        callback = function()
          pcall(vim.cmd, "Neotree close")
        end,
      })
    end,
    keys = {
      {
        "<leader>qc",
        function()
          require("persistence").load()
        end,
        desc = "Load [C]WD Session",
      },
      {
        "<leader>qs",
        function()
          require("persistence").select()
        end,
        desc = "[S]elect Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Load [L]ast Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Stop/[Q]uit Persistence",
      },
      {
        "<leader>qq",
        "<cmd>wqa<cr>",
        desc = "[Q]uit All (write)",
      },
      {
        "<leader>qa",
        "<cmd>qa!<cr>",
        desc = "[Q]uit [A]ll (discard)",
      },
      {
        "<leader>qw",
        "<cmd>wq<cr>",
        desc = "[W]rite & [Q]uit",
      },
      {
        "<leader>qQ",
        "<cmd>q!<cr>",
        desc = "Force [Q]uit buffer",
      },
    },
  },
}
