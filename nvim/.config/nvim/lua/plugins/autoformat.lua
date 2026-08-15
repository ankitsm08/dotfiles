-- Conform can also run multiple formatters sequentially
local ruff_formatter = { "ruff_organize_imports", "ruff_format" }
-- You can use 'stop_after_first' to run the first available formatter from the list
local prettier_formatter = { "prettierd", "prettier", stop_after_first = true }

return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = false, cpp = false }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters = {
        beautysh = {
          prepend_args = { "--indent-size", "2" },
        },
      },
      formatters_by_ft = {
        -- Shells
        sh = { "beautysh" },
        bash = { "beautysh" },
        zsh = { "beautysh" },

        -- Lua
        lua = { "stylua" },

        -- Core
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- TODO: Add zig formatter
        -- zig = { "zigfmt?" },
        java = { "google-java-format" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        python = ruff_formatter,

        -- Web
        javascript = prettier_formatter,
        typescript = prettier_formatter,
        javascriptreact = prettier_formatter,
        typescriptreact = prettier_formatter,
        html = prettier_formatter,
        css = prettier_formatter,
        scss = prettier_formatter,

        -- Docs
        markdown = prettier_formatter,
        liquid = prettier_formatter,

        -- Objects
        json = { "jq" },
        yaml = prettier_formatter,
        toml = { "taplo" },

        -- LaTeX
        tex = { "latexindent" },
        bib = { "bibtex-tidy" },
      },
    },
  },
}
