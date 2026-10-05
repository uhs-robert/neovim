-- lua/plugins/core.lua

local UID = (vim.uv or vim.loop).getuid()
local IS_SUDOEDIT = vim.env.SUDOEDIT == "1"
local IS_ROOT = IS_SUDOEDIT or UID == 0

-- The dotfiles write the palette's scheme here while Settings > Colors > Sync Neovim is on.
local SYNCED_COLORSCHEME_FILE = (vim.env.XDG_STATE_HOME or vim.fs.normalize("~/.local/state"))
  .. "/hypr/nvim-colorscheme"

local get_synced_colorscheme = function()
  local f = io.open(SYNCED_COLORSCHEME_FILE, "r")
  if not f then return nil end
  local name = vim.trim(f:read("*a") or "")
  f:close()
  return name ~= "" and name or nil
end

local get_startup_colorscheme = function()
  local cwd = vim.uv.cwd() or ""
  if IS_ROOT then return "oasis-scorpion" end
  if vim.startswith(cwd, vim.fs.normalize("~/mnt/")) then return "oasis-mirage" end

  return get_synced_colorscheme() or "oasis"
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = get_startup_colorscheme(),
      news = {
        lazyvim = true,
        neovim = true,
      },
    },
  },
}
