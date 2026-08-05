local servers = {
  bashls = {},
  clangd = {
    cmd = { "clangd", "--memory-limit=4096" },
  },
  css_variables = {},
  cssls = {},
  cssmodules_ls = {},
  docker_compose_language_service = {},
  docker_language_server = {},
  eslint = {
    settings = {
      telemetry = { enabled = false },
    },
  },
  gopls = {},
  html = {},
  hyprls = {},
  jdtls = {
    cmd = { "jdtls", "-Dtelemetry.enabled=false" },
  },
  jsonls = {},
  just = {},
  kotlin_lsp = {
    settings = {
      telemetry = { enabled = false },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          disable = { "missing-fields" },
          globals = { "vim" },
        },
        -- Libraries are managed lazily by lazydev.nvim; do not set workspace.library here.
        workspace = {
          checkThirdParty = false,
          maxPreload = 20,
          preloadFileSize = 100,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  marksman = {},
  qmlls = {},
  ruff = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cachePriming = { enable = false },
      },
    },
  },
  sqls = {},
  stylua = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        telemetry = {
          enabled = false,
        },
      },
    },
  },
  taplo = {},
  ty = {},
  vimls = {},
  vtsls = {
    settings = {
      typescript = {
        telemetry = { enable = false },
      },
    },
  },
  yamlls = {},
  zls = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},
}

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  "codelldb", -- Used to debug C/C++/Rust/Zig
  "debugpy", -- Used to debug Python
  "beautysh", -- Used to format shell scripts
  "clang-format", -- Used to format C/C++ code
  "eslint_d", -- Used to lint JavaScript/TypeScript code
  "google-java-format", -- Used to format Java code
  "jq", -- Used to format JSON
  "pgformatter", -- Used to format PostgreSQL code
  "prettierd", -- Used to format HTML/CSS, JavaScript/TypeScript code and Markdown and YAML
  "ruff", -- Used to format and lint Python code
  "stylua", -- Used to format Lua code
  "taplo", -- Used to format TOML
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

return servers
