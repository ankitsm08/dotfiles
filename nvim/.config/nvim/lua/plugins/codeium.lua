return {
  {
    "Exafunction/windsurf.vim",
    event = "VeryLazy",

    -- No UI = no completions to show
    -- also avoids spawning the language server in headless sessions
    cond = function()
      return #vim.api.nvim_list_uis() > 0
    end,

    config = function()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-;>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-f>", function()
        return vim.fn["codeium#AcceptNextWord"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-i>", function()
        return vim.fn["codeium#AcceptNextLine"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-g>", function()
        return vim.fn["codeium#Complete"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
}
