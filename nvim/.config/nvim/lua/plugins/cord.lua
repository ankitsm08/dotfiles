local user_vars = {
  username = "ankitsm08",
  website_url = "https://ankitsm08.github.io",
  github_url = "https://github.com/ankitsm08",
}

-- List of standard public hosts to keep as-is
local public_hosts = {
  ["github.com"] = true,
  ["gitlab.com"] = true,
  ["codeberg.org"] = true,
  ["bitbucket.org"] = true,
  ["gitea.com"] = true,
}

-- Disable automatic startup
vim.g.cord_defer_startup = true

local function get_repository_url(repo_url)
  if not repo_url or repo_url == "" then
    return nil
  end

  -- Clean trailing .git and slashes
  local clean_url = repo_url:gsub("%.git$", ""):gsub("/+$", "")

  local domain, path

  -- Extract domain and path based on connection protocol
  if clean_url:match("^https?://") then
    domain, path = clean_url:match("^https?://([^/]+)/(.+)$")
  elseif clean_url:match("^git@") then
    domain, path = clean_url:match("^git@([^:]+):(.+)$")
  end

  if domain and path then
    -- Strip 'www.' if present for consistent matching
    domain = domain:gsub("^www%.", "")

    -- If it's a known public host, keep it; otherwise, swap to github.com
    if public_hosts[domain] then
      return "https://" .. domain .. "/" .. path
    else
      return "https://github.com/" .. path
    end
  end

  return nil
end

return {
  {
    "vyfor/cord.nvim",
    keys = {
      {
        "<leader>C",
        function()
          require("cord").setup()
        end,
        desc = "[C]ord Start",
      },
    },
    ---@type CordConfig
    opts = {
      variables = {
        username = user_vars.username,
        website_url = user_vars.website_url,
        github_url = user_vars.github_url,
        repository_url = function(opts)
          return get_repository_url(opts.repo_url)
        end,
      },
      display = {
        theme = "default", -- 'default', 'atom', 'catppuccin', 'minecraft', 'void', 'classic'
        flavor = "dark", -- 'dark', 'light', 'accent'
      },
      hooks = {
        post_activity = function(opts, activity)
          activity.type = "playing" -- 'playing' | 'listening' | 'watching' | 'competing'

          local repo = get_repository_url(opts.repo_url)
          if repo then
            activity.state_url = repo
            activity.details_url = repo
            activity.assets.large_url = user_vars.github_url
            activity.assets.small_url = user_vars.github_url
          end
        end,
      },
      buttons = {
        {
          label = function(opts)
            return get_repository_url(opts.repo_url) and "View Repository" or "My Github"
          end,
          url = function(opts)
            return get_repository_url(opts.repo_url) or user_vars.github_url
          end,
        },
        {
          label = function(opts)
            return "My Website"
          end,
          url = function(opts)
            return user_vars.website_url
          end,
        },
      },
      idle = {
        timeout = 32 * 60 * 1000,
        details = function(opts)
          return "Idling on " .. opts.workspace
        end,
        state = "Taking a break!",
        tooltip = "😴",
      },
    },
  },
}
