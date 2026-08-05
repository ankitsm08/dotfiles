---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },

    -- Community-standard keymap set adapted from LazyVim
    keys = {
      {
        "<leader>kB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>kb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>kc",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<leader>ka",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>kC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>kg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>ki",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>kj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>kk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>kl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ko",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>kO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>kP",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>kr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ks",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>kt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>kw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },

    config = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.adapters.python = {
        type = "executable",
        command = "debugpy-adapter",
      }

      -- Python interpreter resolution, mirroring the code_runner venv logic:
      -- active VIRTUAL_ENV -> local .venv -> debugpy's own interpreter.
      local function python_path()
        local env = vim.env.VIRTUAL_ENV
        if env and vim.fn.executable(env .. "/bin/python") == 1 then
          return env .. "/bin/python"
        end
        for _, dir in ipairs({ ".venv", "../.venv" }) do
          local p = vim.fn.getcwd() .. "/" .. dir .. "/bin/python"
          if vim.fn.executable(p) == 1 then
            return p
          end
        end
        return "" -- let debugpy use its bundled interpreter
      end

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = python_path,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach to process",
          connect = { host = "127.0.0.1", port = 5678 },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      -- codelldb covers these too; executables need debug symbols (-g).
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      dap.configurations.zig = dap.configurations.cpp

      -- Breakpoint / stopped-line signs (nerd font icons)
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.fn.sign_define("DapBreakpoint", { text = "󰁔", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "󰁕", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapLogPoint", { text = "󰁍", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DiagnosticInfo", linehl = "DapStoppedLine" })

      -- nvim-dap tip: temporary session-scoped keymaps
      -- so F-keys / arrows only act as debugger controls while
      -- a session is active
      dap.listeners.after.event_initialized["dap_session_keys"] = function()
        local map = vim.keymap.set
        local function mapf(keys, fn, desc)
          map("n", keys, function()
            fn()
          end, { buffer = true, desc = "Debug: " .. desc })
        end
        mapf("<F5>", dap.continue, "Continue")
        mapf("<F9>", dap.toggle_breakpoint, "Toggle breakpoint")
        mapf("<F10>", dap.step_over, "Step over")
        mapf("<F11>", dap.step_into, "Step into")
        mapf("<S-F11>", dap.step_out, "Step out")
        -- Arrow keys resemble the stepping direction
        mapf("<Down>", dap.step_over, "Step over")
        mapf("<Right>", dap.step_into, "Step into")
        mapf("<Left>", dap.step_out, "Step out")
        mapf("<Up>", dap.restart_frame, "Restart frame")
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>ku",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>ke",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "x" },
      },
    },
    opts = {},
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- DAP pickers
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>kT", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Dap: Breakpoints" },
      { "<leader>kV", "<cmd>Telescope dap variables<cr>", desc = "Dap: Variables" },
      { "<leader>kF", "<cmd>Telescope dap frames<cr>", desc = "Dap: Frames" },
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
}
