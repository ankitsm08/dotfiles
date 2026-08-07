-- Secrets live in gitignored files. Read them into the env
-- at load time so nothing sensitive is hardcoded or committed
local key_path = vim.fn.stdpath("config") .. "/obsidian.api_key"

local workspaces = {
  { name = "personal", path = "/home/ank/docs/obsidian/AnkVault" },
}

local bridge_events = {}
for _, ws in ipairs(workspaces) do
  table.insert(bridge_events, "BufReadPre " .. ws.path .. "/*.md")
  table.insert(bridge_events, "BufNewFile " .. ws.path .. "/*.md")
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release
    ft = { "markdown", "quarto" },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in 4.0.0
      workspaces = workspaces,
      frontmatter = {
        enabled = false,
      },
    },
  },
  {
    "oflisback/obsidian-bridge.nvim",
    -- Only load when actually opening a markdown file inside one of the
    -- configured workspaces, mirroring how obsidian.nvim scopes work
    event = bridge_events,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    init = function()
      local key = vim.env.OBSIDIAN_REST_API_KEY
      if key and key ~= "" then
        return
      end
      local f = io.open(key_path, "r")
      if f then
        key = vim.trim(f:read("*a") or "")
        f:close()
        if key ~= "" then
          vim.env.OBSIDIAN_REST_API_KEY = key
        end
      end
    end,
    -- HTTPS/SSL requires the self-signed cert saved to the gitignored path below
    opts = {
      obsidian_server_address = "https://127.0.0.1:27124",
      scroll_sync = true,
      cert_path = vim.fn.stdpath("config") .. "/obsidian.crt",
    },
  },
}
