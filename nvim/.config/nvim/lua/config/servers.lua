local servers = {
  yamlls = {},
  vimls = {},
  marksman = {},
  jsonls = {},
  hyprls = {},
  taplo = {},
  bashls = {},
  docker_language_server = {},
  docker_compose_language_service = {},
  ruff = {},
  rust_analyzer = {},
  cssmodules_ls = {},
  css_variables = {},
  cssls = {},
  tailwindcss = {},
  html = {},
  vtsls = {},
  eslint = {},
  clangd = {},
  -- pyright = {},
  ty = {},
  -- basedpyright = {
  --   settings = {
  --     basedpyright = {
  --       analysis = {
  --         typeCheckignMode = "standard",
  --         diagnosticSeverityOverrides = {
  --           reportUnusedCallResult = "none",
  --         },
  --       },
  --     },
  --   },
  -- },
  gopls = {},
  zls = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},

  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          disable = { "missing-fields" },
        },
        -- -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths here.
            "${3rd}/luv/library",
            "${3rd}/busted/library",
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  "stylua", -- Used to format Lua code
  "beautysh", -- Used to format shell scripts
  "clang-format", -- Used to format C/C++ code
  "ruff", -- Used to format and lint Python code
  "taplo", -- Used to format TOML
  "prettierd", -- Used to format HTML/CSS, JavaScript/TypeScript code and Markdown and YAML
  "prettier", -- Acts as fallback for prettierd
  "jq", -- Used to format JSON
  "eslint_d", -- Used to lint JavaScript/TypeScript code
  "google-java-format", -- Used to format Java code
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

return servers
