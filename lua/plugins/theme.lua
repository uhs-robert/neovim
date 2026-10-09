-- lua/plugins/theme.lua
-- Themes and thematic elements
-- Contains colorschemes, status lines, and elements which use themes
--
local uv = vim.uv or vim.loop
local IS_SUDOEDIT = vim.env.SUDOEDIT == "1"
-- libuv has no getuid on Windows, where there is no root user to detect.
local IS_ROOT = IS_SUDOEDIT or (uv.getuid ~= nil and uv.getuid() == 0)

return {
  -- Melange
  { "savq/melange-nvim", enabled = false },
  --
  -- -- Nightfox
  -- { "EdenEast/nightfox.nvim" },
  --
  -- -- kanagawa
  -- { "rebelot/kanagawa.nvim" },

  -- mfd.nvim
  -- {
  --   "kungfusheep/mfd.nvim",
  --   enabled = false,
  --   lazy = true,
  --   opts = { accessibility_contrast = 2 },
  -- },

  {
    "uhs-robert/color-chameleon.nvim",
    dir = local_plugin("color-chameleon.nvim"),
    lazy = true,
    event = "VeryLazy",
    opts = {
      enabled = true,
      set_on_startup = false,
      rules = {
        {
          colorscheme = "oasis-scorpion",
          condition = function()
            return IS_ROOT
          end,
        },
        { path = "~/mnt/", colorscheme = "oasis-mirage" },
        {
          -- Night time colorscheme
          colorscheme = "oasis-night",
          condition = function()
            local hour = tonumber(os.date("%H"))
            local month = tonumber(os.date("%m"))
            local is_summer = month >= 5 and month <= 9
            local is_winter = month == 12 or month <= 2

            if is_summer then
              return hour <= 6 or hour >= 18 -- Before 6AM, after 6PM
            elseif is_winter then
              return hour <= 7 or hour >= 16 -- Before 7AM, after 4PM
            else
              return hour <= 7 or hour >= 17 -- Before 7AM, after 5PM
            end
          end,
        },
      },
      default = "oasis",
    },
  },

  -- Oasis
  {
    "uhs-robert/oasis.nvim",
    dir = local_plugin("oasis.nvim"),
    lazy = false,
    priority = 1000,
    opts = {
      style = "moonlight",
      -- dark_style = "sol",
      -- light_style = "night",
      -- light_intensity = 3,
      -- dark_intensity = 2,
      contrast = {
        -- min_ratio = 5.8,
        -- force_aaa = false,
      },
      -- themes = {
      --   sol = {
      --     dark_intensity = 5,
      --   },
      -- },
      integrations = {
        plugins = {
          -- snacks = false,
        },
      },
      -- themed_syntax = false,
      -- use_legacy_comments = true,
      -- styles = {
      --   italic = false,
      --   underline = false,
      --   undercurl = false,
      --   bold = false,
      --   strikethrough = false,
      -- },
      -- terminal_colors = false,
      -- transparent = true,
      highlight_overrides = function(c, colors)
        ---@type OasisHighlightOverrides
        return {
          -- Comment = { fg = c.fg.dim },
          -- desert = {
          --   Comment = { fg = c.syntax.preproc },
          -- },
          -- lagoon = {
          --   light_3 = {
          --     Comment = { fg = "#FFF000" },
          --   },
          -- },
          -- light = {
          --   Comment = { fg = "#FF0000" },
          -- },
          -- light_5 = {
          --   Comment = { fg = "#FFA000" },
          -- },
        }
      end,
      palette_overrides = function(c, colors)
        ---@type OasisPaletteOverrides
        return {
          -- night = {
          --   bg = colors.theme.midnight.bg,
          -- },
          -- desert = {
          --   syntax = {
          --     string = colors.rose[500],
          --   },
          -- },
        }
      end,
    },
    keys = {
      { "<leader>Cl", "<cmd>OasisIntensity<cr>", desc = "Oasis Intensity" },
    },
  },

  {
    "uhs-robert/jewel.nvim",
    dir = local_plugin("jewel.nvim"),
    lazy = false,
    priority = 1000,
    opts = {
      style = "diamond",
      integrations = {
        plugins = {
          -- snacks = false,
        },
      },
    },
  },

  -- All Your Base
  -- {
  --   -- "uhs-robert/allyourbase.nvim",
  --   dir = vim.env.HOME .. "/Development/allyourbase.nvim/",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("allyourbase").setup({
  --       colors = {
  --         color0 = "#101825",
  --       },
  --     })
  --   end,
  -- },

  -- Lush
  -- {
  --   "rktjmp/lush.nvim",
  -- },
  -- {
  --   "rktjmp/shipwright.nvim",
  -- },

  -- Lualine: Enhanced statusline with time display and file manager integration
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = "LazyFile",
    opts = function(_, opts)
      opts.options.theme = "oasis"
      opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
        lualine_z = {
          {
            function()
              return os.date("%I:%M:%S %p")
            end,
            icon = "󰥔",
          },
        },
      })
      if opts.sections and opts.sections.lualine_c then
        for _, section in ipairs(opts.sections.lualine_c) do
          section.on_click = function()
            local file_path = vim.fn.expand("%:p:h") -- Get file's directory
            vim.fn.jobstart({ "thunar", file_path }, { detach = true }) -- Open Thunar
          end
        end
      end
    end,
  },

  -- mini.tabline: test-only tabline for oasis
  -- {
  --   "nvim-mini/mini.nvim",
  --   lazy = true,
  --   event = "VimEnter",
  --   config = function()
  --     require("mini.tabline").setup()
  --   end,
  -- },

  -- Tabby: Enhanced tab viewer with slanted element design and which-key binds
  {
    "nanozuki/tabby.nvim",
    lazy = true,
    event = "VimEnter",
    -- event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- always show tabline; sessions will restore tab pages + names
      vim.o.showtabline = 2
      vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
    end,
    ---@type TabbyConfig
    opts = {
      preset = "active_wins_at_tail",
      option = {
        nerdfont = true,
        buf_name = { mode = "unique" },
        -- lualine_theme = "auto",
      },
    },
    keys = {
      {
        "<leader><tab>h",
        "<cmd>tabprevious<cr>",
        desc = "Prev tab",
      },
      {
        "<leader><tab>l",
        "<cmd>tabnext<cr>",
        desc = "Next tab",
      },
      {
        "<leader><tab>d",
        "<cmd>tabclose<cr>",
        desc = "Delete tab",
      },
      {
        "<leader><tab>L",
        "<cmd>+tabmove<cr>",
        desc = "Move tab right",
      },
      {
        "<leader><tab>H",
        "<cmd>-tabmove<cr>",
        desc = "Move tab left",
      },
      {
        "<leader><tab>w",
        "<cmd>Tabby pick_window<cr>",
        desc = "Pick tab window",
      },
      {
        "<leader><tab>j",
        "<cmd>Tabby jump_to_tab<cr>",
        desc = "Jump to tab",
      },
    },
  },
}
