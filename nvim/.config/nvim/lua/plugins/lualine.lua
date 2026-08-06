return {
  {
    "SmiteshP/nvim-navic",
    event = "UIEnter",
    opts = {
      lsp = {
        auto_attach = true,
        preference = { "obsidian-ls", "marksman" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
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
              return "DEBUG"
            end,
            cond = function()
              if not package.loaded["dap"] then
                return false
              end
              local ok, session = pcall(require("dap").session)
              return ok and session ~= nil
            end,
            padding = { left = 1, right = 1 },
          },
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
