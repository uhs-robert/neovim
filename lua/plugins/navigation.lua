-- lua/plugins/navigation.lua
-- Navigation and file management tools
-- Contains tmux navigation, file managers, scrolling, and workflow productivity tools
return {
  -- Tmux Navigator: Seamless navigation between Vim and tmux panes
  -- Navigate between Vim splits and tmux panes using consistent keybindings (Ctrl+hjkl)
  {
    "christoomey/vim-tmux-navigator", -- tmux navigation for vim and neovim, also supports tmux-res'
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Volt: Base dependency for NVZone plugins (lazy loaded)
  -- Required dependency for typr and other NVZone utilities
  { "nvzone/volt", lazy = true },

  -- Minty: Color picker and shade generator tools
  -- Provides :Shades and :Huefy commands for color manipulation and selection
  {
    "nvzone/minty",
    lazy = true,
    cmd = { "Shades", "Huefy" },
  },

  -- Neoscroll: Smooth scrolling animations for better visual feedback
  -- Provides smooth scrolling for Ctrl+u/d, Ctrl+b/f, and other scroll commands
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      duration_multiplier = 1.0, -- Global duration multiplier
      easing = "linear", -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
      ignored_events = { -- Events ignored while scrolling
        "WinScrolled",
        "CursorMoved",
      },
    },
  },

  -- Rooter: Automatic project root detection and directory changing
  -- Changes working directory to project root based on common markers (.git, package.json)
  {
    "notjedi/nvim-rooter.lua",
    lazy = true,
    event = "VeryLazy",
    opts = {},
  },

  -- Oil: File manager that treats directories as editable buffers
  -- Edit directories like normal buffers with familiar Vim commands and motions
  -- {
  --   "stevearc/oil.nvim",
  --   opts = {},
  --   dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  --   -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  --   lazy = false,
  -- },

  -- Yazi: Terminal file manager integration with advanced file operations
  -- Fast file navigation, preview, and batch operations with multiple keybinding options
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    -- dependencies = { "folke/snacks.nvim", lazy = true },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>yy",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>yh",
        function()
          require("yazi").yazi(nil, "~")
        end,
        desc = "Open Yazi from home directory",
      },
      {
        "<leader>ym",
        function()
          require("yazi").yazi(nil, "~/mnt")
        end,
        desc = "Open Yazi from mounted directory",
      },
      {
        -- Open in the current working directory
        "<leader>yw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>yt",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      -- open_for_directories = true,
      enable_mouse_support = true,
      keymaps = {
        show_help = "<f1>",
      },
      hooks = {
        yazi_closed_successfully = function(chosen_file, config, state)
          -- vim.notify(vim.inspect({ chosen_file, state.last_directory.filename }))
        end,
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    -- init = function()
    --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    --   -- vim.g.loaded_netrw = 1
    --   -- vim.g.loaded_netrwPlugin = 1
    -- end,
  },
  -- -- Fzf lua
  -- {
  --   "ibhagwan/fzf-lua",
  --   -- optional for icon support
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   -- dependencies = { "nvim-mini/mini.icons" },
  --   cmd = "FzfLua",
  --   opts = {},
  -- },
}
