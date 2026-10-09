-- scripts/readme_plugins.lua
-- Rewrites the README's plugin list (between the plugins:start/end markers) from lua/plugins/*.lua.
-- Run from inside Neovim with this config loaded, which .githooks/pre-commit does:
--   nvim --headless -c "luafile scripts/readme_plugins.lua" -c "qa!"
--
-- Lists only plugins this config adds: specs that configure something LazyVim or one of its
-- extras already provides (lualine, snacks, ...) are left out, as are specs with enabled = false
-- and bare library entries like { "nvzone/volt", lazy = true }. Each file in lua/plugins/ becomes
-- one group, named after the file.

local repo_root = vim.fs.dirname(vim.fs.dirname(vim.fs.normalize(debug.getinfo(1, "S").source:sub(2))))
local readme_path = repo_root .. "/README.md"
local START_MARKER = "<!-- plugins:start -->"
local END_MARKER = "<!-- plugins:end -->"

local function fail(message)
  io.stderr:write("readme_plugins: " .. message .. "\n")
  vim.cmd("cquit 1")
end

-- Every language extra is included regardless of its toolchain check, so the list comes out the
-- same on every machine.
local function lazyvim_plugin_names()
  local specs = { { "LazyVim/LazyVim", import = "lazyvim.plugins" } }
  for _, extra in ipairs(dofile(repo_root .. "/lua/config/language_extras.lua")) do
    specs[#specs + 1] = { import = extra.import }
  end
  local Spec = require("lazy.core.plugin").Spec
  local names = {}
  -- Without optional = true, plugins LazyVim only mentions as optional (yazi.nvim) are dropped,
  -- since it does not install those itself.
  for name in pairs(Spec.new(specs).plugins) do
    names[name] = true
  end
  return names
end

-- A spec that only says lazy = true exists to be loaded by another plugin, never on its own.
local function is_library_entry(spec)
  if spec.lazy ~= true then return false end
  for key in pairs(spec) do
    if key ~= 1 and key ~= "lazy" then return false end
  end
  return true
end

-- Top-level specs only: dependencies are an implementation detail of the plugin that needs them.
local function added_plugins(spec_file, provided_names)
  local plugins = {}
  for _, spec in ipairs(dofile(spec_file)) do
    local source = type(spec) == "table" and spec[1]
    if type(source) == "string" and source:find("/") and spec.enabled ~= false and not is_library_entry(spec) then
      local repo_name = source:match("[^/]+$")
      if not provided_names[repo_name] then plugins[#plugins + 1] = source end
    end
  end
  return plugins
end

local GROUP_TITLE_OVERRIDES = { lsp = "LSP", ai = "AI" }

local function group_title(spec_file)
  local name = vim.fn.fnamemodify(spec_file, ":t:r")
  if GROUP_TITLE_OVERRIDES[name] then return GROUP_TITLE_OVERRIDES[name] end
  name = name:gsub("[_-]", " ")
  return name:sub(1, 1):upper() .. name:sub(2)
end

local function render_list(provided_names)
  local spec_files = vim.fn.glob(repo_root .. "/lua/plugins/*.lua", false, true)
  table.sort(spec_files)
  local lines = {}
  for _, spec_file in ipairs(spec_files) do
    local plugins = added_plugins(spec_file, provided_names)
    if #plugins > 0 then
      local links = vim.tbl_map(function(source)
        return string.format("[%s](https://github.com/%s)", source:match("[^/]+$"), source)
      end, plugins)
      lines[#lines + 1] = string.format("- **%s:** %s", group_title(spec_file), table.concat(links, ", "))
    end
  end
  return lines
end

local ok, provided_or_error = pcall(lazyvim_plugin_names)
if not ok then return fail("could not read LazyVim's plugins: " .. tostring(provided_or_error)) end

local readme = io.open(readme_path, "r")
if not readme then return fail("cannot read " .. readme_path) end
local content = readme:read("*a")
readme:close()

local before, after = content:match("^(.-" .. vim.pesc(START_MARKER) .. "\n).-(" .. vim.pesc(END_MARKER) .. ".*)$")
if not before then return fail("README.md has no " .. START_MARKER .. " / " .. END_MARKER .. " section") end

local list = table.concat(render_list(provided_or_error), "\n")
local updated = before .. "\n" .. list .. "\n\n" .. after
if updated ~= content then
  readme = io.open(readme_path, "w")
  if not readme then return fail("cannot write " .. readme_path) end
  readme:write(updated)
  readme:close()
end
