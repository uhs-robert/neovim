-- lua/config/machine_settings.lua
-- Per-machine opt-outs, read from the untracked lua/config/machine.lua:
--   return {
--     preset = "minimal",                         -- a bundle from lua/config/presets.lua
--     disabled_groups = { "remote" },             -- whole lua/plugins/*.lua files, by file name
--     disabled_extras = { "lang.astro" },         -- extras from lua/config/language_extras.lua
--     disabled_plugins = { "smear-cursor.nvim" }, -- any plugin, by its name in :Lazy
--   }

-- Checked for rather than wrapped in pcall, so a mistake inside machine.lua still raises an error
-- instead of silently looking like an absent file.
local has_machine_file = #vim.api.nvim_get_runtime_file("lua/config/machine.lua", false) > 0
local machine = has_machine_file and require("config.machine") or {}

local settings = { disabled_groups = {}, disabled_extras = {}, disabled_plugins = {} }

local function add_lists(source)
  for key, list in pairs(settings) do
    vim.list_extend(list, source[key] or {})
  end
end

if machine.preset then
  local preset = require("config.presets")[machine.preset]
  if preset then
    add_lists(preset)
  else
    vim.notify(
      ("machine.lua: unknown preset %q, see lua/config/presets.lua"):format(machine.preset),
      vim.log.levels.WARN
    )
  end
end
add_lists(machine)

return settings
