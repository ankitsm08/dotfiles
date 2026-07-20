return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    opts = {
      provider_selector = function(_, _, _)
        return { "lsp", "indent" }
      end,
    },
    keys = {
      {
        "<leader>tf",
        function()
          vim.o.foldenable = not vim.o.foldenable
          vim.notify("Folds: " .. (vim.o.foldenable and "on" or "off"), vim.log.levels.INFO)
        end,
        desc = "[T]oggle [F]olds",
      },
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = false
    end,
  },
}
