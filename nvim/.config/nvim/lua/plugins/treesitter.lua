return {
  { "NMAC427/guess-indent.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = false },
      ensure_installed = {
        -- Languages
        "c",
        "cpp",
        "rust",
        "zig",
        "python",
        "java",

        -- Scripting
        "lua",
        "bash",
        "zsh",
        "powershell",

        -- Build Tools
        "just",
        "make",
        "cmake",

        -- Web
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "jsx",
        "tsx",

        -- Data
        "json",
        "yaml",
        "toml",
        "ini",
        "csv",
        "xml",

        -- Docs
        "markdown",
        "markdown_inline",
        "vimdoc",

        -- VCS
        "gitcommit",
        "gitignore",
        "git_config",

        -- Containers
        "dockerfile",

        -- Editor
        "vim",
        "diff",
        "regex",
        "printf",

        -- OS / Config
        "desktop",
        "ssh_config",
        "hyprlang",
        "editorconfig",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)

      local parsers = TS.get_installed()

      vim.filetype.add({
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
          [".*/kitty/.*%.conf"] = "kitty",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })

      -- vim.defer_fn(function()
      --   require("nvim-treesitter").install(parsers)
      -- end, 0)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    -- Only relevant in markup-ish filetypes; load when one is opened
    ft = {
      "html", "xml", "heex", "svelte", "templ", "rust", "glimmer",
      "typescriptreact", "javascriptreact",
      "vue", "astro", "markdown", "php", "eruby", "liquid", "twig",
      "blade", "elixir", "handlebars", "hbs",
    },
    opts = {},
  },
}
