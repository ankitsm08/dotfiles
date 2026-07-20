return {
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })
    end,
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
