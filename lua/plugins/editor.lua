-- lua/plugins/editor.lua
-- Core editor enhancements and productivity tools
-- Contains plugins for folding, undo management, centering, text objects, syntax parsing, and editor behavior improvements
return {

  -- Treesitter: Syntax highlighting and parsing engine
  -- Extended parser list for better syntax support across multiple languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = { enable = true }, ---@type lazyvim.TSFeat
      highlight = { enable = true }, ---@type lazyvim.TSFeat
      folds = { enable = true }, ---@type lazyvim.TSFeat
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "css",
        "diff",
        "gotmpl",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        -- Highlighting everywhere; lang.php (lua/config/extras.lua) only loads where PHP is installed.
        "php",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },

  -- MDX filetype with Treesitter highlighting
  {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = {
      "BufReadPre *.mdx",
      "BufNewFile *.mdx",
    },
  },

  -- Pretty Fold: Enhanced fold text display
  -- Improves the appearance of folded code blocks with better formatting
  {
    "anuvyklack/pretty-fold.nvim",
  },

  -- Spider: Enhanced word movement that skips punctuation
  -- Smarter w, e, b motions that ignore insignificant punctuation for cleaner navigation
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "x", "o" } },
      { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "x", "o" } },
      { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "x", "o" } },
    },
    opts = {
      skipInsignificantPunctuation = true,
    },
  },

  -- Various Text Objects: Additional text objects for enhanced editing
  -- Provides extra text objects like entire buffer, visible area, URLs, numbers, etc.
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },

  -- HelpView: Enhanced help documentation with better formatting and syntax highlighting
  -- Improves the appearance and readability of Neovim's built-in help files
  {
    "OXY2DEV/helpview.nvim",
    -- It loads itself on help buffers; lazy = true with no trigger meant it never loaded at all.
    lazy = false,
  },

  -- Inc-Rename
  {
    "smjonas/inc-rename.nvim",
    opts = {},
    keys = {
      { "<leader>rn", ":IncRename ", desc = "IncRename" },
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "IncRename (word)",
      },
    },
  },
}
