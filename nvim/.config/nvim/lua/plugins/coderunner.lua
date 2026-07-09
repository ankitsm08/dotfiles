local TMP = "/tmp/coderunner"

-- DRY helper function for compiled languages
-- It checks if we are inside a project. If yes, it runs the project command
-- If not, it safely compiles the isolated file into the /tmp/ directory and runs it.
local function smart_runner(opts)
  local cmds = { "cd $dir &&" }

  if opts.project_check and opts.project_cmd then
    table.insert(cmds, "if " .. opts.project_check .. "; then")
    table.insert(cmds, opts.project_cmd .. ";")
    table.insert(cmds, "else")
  end

  if opts.single_build then
    table.insert(cmds, "mkdir -p " .. TMP .. " &&")
    table.insert(cmds, opts.single_build .. " &&")
  end

  table.insert(cmds, opts.single_run .. ";")

  if opts.project_check and opts.project_cmd then
    table.insert(cmds, "fi")
  end

  return table.concat(cmds, " ")
end

-- Python is complex due to virtual environments.
-- This shell string checks for active venvs, uv, poetry, or local .venv folders.
local python_smart_runner = table.concat({
  "cd $dir &&",
  -- If a virtual env is actively sourced in the terminal/nvim, use it
  'if [ -n "$VIRTUAL_ENV" ]; then python3 -u $fileName;',
  -- If `uv` is installed, let it natively resolve the workspace/venv or use an ephemeral one
  "elif command -v uv >/dev/null 2>&1; then uv run python -u $fileName;",
  -- If `poetry` is installed and we are inside a poetry project
  "elif command -v poetry >/dev/null 2>&1 && poetry env info >/dev/null 2>&1; then poetry run python -u $fileName;",
  -- Fallback: check for local .venv in the current or parent directory
  "elif [ -f .venv/bin/python ]; then .venv/bin/python -u $fileName;",
  "elif [ -f ../.venv/bin/python ]; then ../.venv/bin/python -u $fileName;",
  -- Last fallback: System Python
  "else python3 -u $fileName; fi",
}, " ")

return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    keys = {
      { "<leader>rr", "<cmd>RunCode<CR>", desc = "Run code" },
      { "<leader>rf", "<cmd>RunFile<CR>", desc = "Run file" },
      { "<leader>rft", "<cmd>RunFile tab<CR>", desc = "Run file (tab)" },
      { "<leader>rp", "<cmd>RunProject<CR>", desc = "Run project" },
      { "<leader>rc", "<cmd>RunClose<CR>", desc = "Close runner" },
    },
    opts = {
      mode = "term",
      focus = true,
      startinsert = true,
      term = {
        position = "belowright",
        size = 14,
      },
      filetype = {
        -- Python
        python = python_smart_runner,

        -- Rust (checks if inside a cargo workspace)
        rust = smart_runner({
          project_check = "cargo locate-project >/dev/null 2>&1",
          project_cmd = "cargo run",
          single_build = "rustc $fileName -g -o " .. TMP .. "/$fileNameWithoutExt",
          single_run = TMP .. "/$fileNameWithoutExt",
        }),

        -- Go (checks if inside a go module)
        go = smart_runner({
          project_check = "go env GOMOD | grep -q -v '/dev/null'",
          project_cmd = "go run .",
          single_build = "go build -o " .. TMP .. "/$fileNameWithoutExt $fileName",
          single_run = TMP .. "/$fileNameWithoutExt",
        }),

        -- C (uses clang for compilation)
        c = smart_runner({
          project_check = "[ -f Makefile ] || [ -f ../Makefile ]",
          project_cmd = "make",
          single_build = "clang $fileName -g -Wall -Wextra -std=c11 -o " .. TMP .. "/$fileNameWithoutExt",
          single_run = TMP .. "/$fileNameWithoutExt",
        }),

        -- C++ (uses clang++ for compilation)
        cpp = smart_runner({
          project_check = "[ -f Makefile ] || [ -f ../Makefile ]",
          project_cmd = "make",
          single_build = "clang++ $fileName -fsanitize=address -g -Wall -Wextra -std=c++17 -o "
            .. TMP
            .. "/$fileNameWithoutExt",
          single_run = TMP .. "/$fileNameWithoutExt",
        }),

        -- Java
        java = smart_runner({
          single_build = "javac -g -d " .. TMP .. " $fileName",
          single_run = "java -cp " .. TMP .. " $fileNameWithoutExt",
        }),

        -- Zig
        zig = smart_runner({
          single_build = "zig build-exe $fileName -femit-bin=" .. TMP .. "/$fileNameWithoutExt",
          single_run = TMP .. "/$fileNameWithoutExt",
        }),

        -- Node / TypeScript (for JS/TS, use tools that natively respect package.json)
        javascript = "node $fileName",
        typescript = "pnpx ts-node $fileName",
        javascriptreact = "pnpm start",
        typescriptreact = "pnpm start",

        -- Other Scripting Languages
        ruby = "ruby $fileName",
        lua = "lua $fileName",
        sh = "bash $fileName",
      },
    },
  },
}
