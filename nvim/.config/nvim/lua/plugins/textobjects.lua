return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    deps = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- mini.ai owns all `a`/`i` textobjects (see lua/plugins/mini.lua).
      -- This plugin provides code navigation (move), swap, and repeatable motions.
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- Jump to next object start
      vim.keymap.set("n", "]f", function()
        move.goto_next_start("@call.outer")
      end, { desc = "Next function call start" })
      vim.keymap.set("n", "]m", function()
        move.goto_next_start("@function.outer")
      end, { desc = "Next method/function def start" })
      vim.keymap.set("n", "]c", function()
        move.goto_next_start("@class.outer")
      end, { desc = "Next class start" })
      vim.keymap.set("n", "]i", function()
        move.goto_next_start("@conditional.outer")
      end, { desc = "Next conditional start" })
      vim.keymap.set("n", "]l", function()
        move.goto_next_start("@loop.outer")
      end, { desc = "Next loop start" })
      vim.keymap.set("n", "]s", function()
        move.goto_next_start("@scope", "locals")
      end, { desc = "Next scope" })
      vim.keymap.set("n", "]z", function()
        move.goto_next_start("@fold", "folds")
      end, { desc = "Next fold" })

      -- Jump to next object end
      vim.keymap.set("n", "]F", function()
        move.goto_next_end("@call.outer")
      end, { desc = "Next function call end" })
      vim.keymap.set("n", "]M", function()
        move.goto_next_end("@function.outer")
      end, { desc = "Next method/function def end" })
      vim.keymap.set("n", "]C", function()
        move.goto_next_end("@class.outer")
      end, { desc = "Next class end" })
      vim.keymap.set("n", "]I", function()
        move.goto_next_end("@conditional.outer")
      end, { desc = "Next conditional end" })
      vim.keymap.set("n", "]L", function()
        move.goto_next_end("@loop.outer")
      end, { desc = "Next loop end" })

      -- Jump to previous object start
      vim.keymap.set("n", "[f", function()
        move.goto_previous_start("@call.outer")
      end, { desc = "Prev function call start" })
      vim.keymap.set("n", "[m", function()
        move.goto_previous_start("@function.outer")
      end, { desc = "Prev method/function def start" })
      vim.keymap.set("n", "[c", function()
        move.goto_previous_start("@class.outer")
      end, { desc = "Prev class start" })
      vim.keymap.set("n", "[i", function()
        move.goto_previous_start("@conditional.outer")
      end, { desc = "Prev conditional start" })
      vim.keymap.set("n", "[l", function()
        move.goto_previous_start("@loop.outer")
      end, { desc = "Prev loop start" })

      -- Jump to previous object end
      vim.keymap.set("n", "[F", function()
        move.goto_previous_end("@call.outer")
      end, { desc = "Prev function call end" })
      vim.keymap.set("n", "[M", function()
        move.goto_previous_end("@function.outer")
      end, { desc = "Prev method/function def end" })
      vim.keymap.set("n", "[C", function()
        move.goto_previous_end("@class.outer")
      end, { desc = "Prev class end" })
      vim.keymap.set("n", "[I", function()
        move.goto_previous_end("@conditional.outer")
      end, { desc = "Prev conditional end" })
      vim.keymap.set("n", "[L", function()
        move.goto_previous_end("@loop.outer")
      end, { desc = "Prev loop end" })

      -- Swap with next/previous
      vim.keymap.set("n", "<leader>na", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap parameter with next" })
      vim.keymap.set("n", "<leader>n:", function()
        swap.swap_next("@property.outer")
      end, { desc = "Swap property with next" })
      vim.keymap.set("n", "<leader>nm", function()
        swap.swap_next("@function.outer")
      end, { desc = "Swap function with next" })
      vim.keymap.set("n", "<leader>pa", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap parameter with previous" })
      vim.keymap.set("n", "<leader>p:", function()
        swap.swap_previous("@property.outer")
      end, { desc = "Swap property with previous" })
      vim.keymap.set("n", "<leader>pm", function()
        swap.swap_previous("@function.outer")
      end, { desc = "Swap function with previous" })

      -- Repeat ; and , : flash char motion, treesitter move, or native, last used
      local function flash_char()
        local ok, char = pcall(require, "flash.plugins.char")
        return ok and char or nil
      end

      local function repeat_last(key)
        local char = flash_char()
        -- char.char: flash's motion defaults to "f" before any search, so a
        -- bare `;` falls through to native instead of flash's char prompt
        if char and char.motion ~= "" and char.char then
          char.jump(key)
        elseif repeat_move.last_move then
          repeat_move[key == ";" and "repeat_last_move" or "repeat_last_move_opposite"]()
        else
          vim.cmd("normal! " .. key)
        end
      end

      -- Treesitter moves reset flash's char state so a stale f/F/t/T can't win
      for _, name in ipairs({ "goto_next_start", "goto_next_end", "goto_previous_start", "goto_previous_end" }) do
        local fn = move[name]
        move[name] = function(...)
          local char = flash_char()
          if char then
            char.motion = ""
          end
          return fn(...)
        end
      end

      -- flash owns f/F/t/T; `;`/`,` repeat whichever motion was last
      for _, key in ipairs({ ";", "," }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          repeat_last(key)
        end, { desc = "Repeat last flash char or treesitter move" })
      end
    end,
  },
}
