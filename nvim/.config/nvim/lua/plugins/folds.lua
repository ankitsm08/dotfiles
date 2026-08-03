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
  },
}
