-- lua/config/plugin_groups.lua
-- Imports each lua/plugins/*.lua file as its own group, so a machine can switch groups off with
-- disabled_groups in lua/config/machine.lua (directly or through a preset).
--
-- A switched-off group is still imported, with every spec marked optional. lazy.nvim drops an
-- optional spec unless the plugin is also defined elsewhere, so the group's own plugins disappear
-- while its settings for LazyVim's plugins (lualine in theme.lua, treesitter in editor.lua) still
-- apply. That is what makes every group safe to switch off.

local disabled_groups = require("config.machine_settings").disabled_groups

local function as_optional(specs)
  return vim.tbl_map(function(spec)
    if type(spec) == "string" then return { spec, optional = true } end
    -- A nested list of specs rather than a single spec.
    if type(spec[1]) == "table" then return as_optional(spec) end
    return vim.tbl_extend("force", spec, { optional = true })
  end, specs)
end

local group_names = vim.tbl_map(function(path)
  return vim.fn.fnamemodify(path, ":t:r")
end, vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", false, true))
table.sort(group_names)

for _, name in ipairs(disabled_groups) do
  if not vim.tbl_contains(group_names, name) then
    vim.notify(("machine.lua: no plugin group %q in lua/plugins/"):format(name), vim.log.levels.WARN)
  end
end

return vim.tbl_map(function(name)
  local module = "plugins." .. name
  if not vim.tbl_contains(disabled_groups, name) then return { import = module } end
  return {
    name = module,
    import = function()
      return as_optional(require(module))
    end,
  }
end, group_names)
