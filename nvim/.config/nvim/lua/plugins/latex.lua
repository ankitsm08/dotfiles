return {
  {
    "lervag/vimtex",
    lazy = true,
    ft = { "tex", "latex", "bib" },
    init = function()
      -- PDF viewer: zathura gives SyncTeX forward/reverse search on Linux
      vim.g.vimtex_view_method = "zathura"
      -- Compile continuously with latexmk (pandoc-independent, standard stack)
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
        continuous = 1,
      }
      -- Open a single quickfix window for errors
      vim.g.vimtex_quickfix_mode = 1
      -- Enable VimTeX's own folding
      vim.g.vimtex_fold_enabled = 1
    end,
  },
}
