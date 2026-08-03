return {
  {
    "folke/persistence.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("persistence").setup(opts)
      local manager = require("neo-tree.sources.manager")
      local renderer = require("neo-tree.ui.renderer")
      local function neotree_is_open()
        return renderer.window_exists(manager.get_state("filesystem"))
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        callback = function()
          vim.g.NEOTREE_LAST_OPENED = neotree_is_open()
          pcall(vim.cmd, "Neotree close")
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceLoadPost",
        callback = function()
          if vim.g.NEOTREE_LAST_OPENED then
            vim.g.NEOTREE_LAST_OPENED = false
            vim.schedule(function()
              vim.cmd("Neotree filesystem show")
            end)
          end
        end,
      })
      if vim.fn.argc() == 0 and vim.fn.getcwd() ~= vim.env.HOME then
        vim.schedule(function()
          require("persistence").load()
        end)
      end
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
