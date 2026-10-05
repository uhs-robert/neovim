-- lua/plugins/snacks.lua
local HEADERS = {
  neovim = [[
                                                                   
      ████ ██████           █████      ██    UpHill Solutions
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
 ]],
}

-- Hide default colorschemes from Snacks Picker
local hidden_colorschemes = {
  blue = true,
  darkblue = true,
  -- default = true,
  delek = true,
  -- desert = true,
  elflord = true,
  -- evening = true,
  industry = true,
  -- koehler = true,
  morning = true,
  murphy = true,
  -- lunaperche = true,
  pablo = true,
  peachpuff = true,
  quiet = true,
  ron = true,
  shine = true,
  -- slate = true,
  torte = true,
  unokai = true,
  zaibatsu = true,
  zellner = true,
}

-- The oasis-dots showcase starts Neovim with OASIS_DEMO set, which keeps the lists of personal paths off camera.
local IS_DEMO = vim.env.OASIS_DEMO ~= nil

-- Dashboard configuration and startup screen customization
-- Contains Snacks.nvim dashboard setup with UpHill Solutions branding and custom theming
return {
  -- Snacks: Multi-purpose UI and utility plugin with dashboard and word highlighting
  -- Custom dashboard with UpHill Solutions branding and enhanced word navigation
  {
    "folke/snacks.nvim",
    opts = {
      ---@class snacks.dashboard.Config
      dashboard = {
        sections = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          { padding = 0, align = "center", text = { HEADERS.neovim, hl = "header" } },
          ---@diagnostic disable-next-line: assign-type-mismatch
          { padding = 2, align = "center", text = { "[ https://uphillsolutions.tech ]", hl = "OasisAccent" } },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
            enabled = not IS_DEMO,
          },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, enabled = not IS_DEMO },
          { section = "startup" },
        },
      },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>1",
        function()
          if vim.bo.filetype ~= "snacks_dashboard" then require("snacks").dashboard.open() end
        end,
        desc = "Home",
      },
      {
        "<leader>e",
        function()
          require("snacks.explorer").open({ hidden = false, cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root)",
      },
      {
        "<leader>E",
        function()
          require("snacks.explorer").open({ hidden = false, cwd = vim.fn.getcwd() })
        end,
        desc = "Explorer Snacks (cwd)",
      },
      {
        "<leader>fe",
        function()
          require("snacks.explorer").open({ hidden = true, cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root -hidden)",
      },
      {
        "<leader>fE",
        function()
          require("snacks.explorer").open({ hidden = true, cwd = vim.fn.getcwd() })
        end,
        desc = "Explorer Snacks (cwd -hidden)",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes({
            transform = function(item)
              local name = item.text or item.name

              if hidden_colorschemes[name] then return false end

              return item
            end,
          })
        end,
        desc = "Colorschemes",
      },
    },
  },
}
