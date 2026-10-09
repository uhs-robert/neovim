-- lua/config/machine_settings.lua
-- Per-machine opt-outs, read from the untracked lua/config/machine.lua:
--   return {
--     disabled_extras = { "lang.astro" },         -- extras from lua/config/language_extras.lua
--     disabled_plugins = { "smear-cursor.nvim" }, -- any plugin, by its name in :Lazy
--   }

-- Checked for rather than wrapped in pcall, so a mistake inside machine.lua still raises an error
-- instead of silently looking like an absent file.
local has_machine_file = #vim.api.nvim_get_runtime_file("lua/config/machine.lua", false) > 0
local machine = has_machine_file and require("config.machine") or {}

return {
  disabled_extras = machine.disabled_extras or {},
  disabled_plugins = machine.disabled_plugins or {},
}
