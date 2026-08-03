return {
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      lsp = {
        auto_attach = true,
        preference = { "obsidian-ls", "marksman" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = vim.g.have_nerd_font,
        theme = "auto",
      },
      sections = {
        lualine_c = {
          { "filename", path = 1 },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return pcall(require("nvim-navic").is_available)
            end,
          },
        },
      },
    },
  },
}
