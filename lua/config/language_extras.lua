-- lua/config/language_extras.lua
-- LazyVim extras whose Mason tools need a language toolchain (npm, pip, go, gem, cargo).
-- Each is imported only where that toolchain exists, so Mason never tries to install a server it
-- has no runtime for. Extras that need no toolchain stay in lazyvim.json.
--
-- To skip one on a single machine anyway, list it in the untracked lua/config/machine.lua:
--   return { disabled_extras = { "lang.astro" } }

local IS_WINDOWS = vim.fn.has("win32") == 1

-- Windows puts python.exe stubs under WindowsApps that only open the Microsoft Store.
local function has(executable)
  local path = vim.fn.exepath(executable)
  return path ~= "" and not (IS_WINDOWS and path:find("WindowsApps", 1, true) ~= nil)
end

local toolchain_available = {
  node = function() return has("node") end,
  python = function() return has("python3") or has("python") end,
  go = function() return has("go") end,
  ruby = function() return has("ruby") end,
  cargo = function() return has("cargo") end,
}

-- Ordered as LazyVim's own extras loader would (lazyvim/plugins/xtras.lua): typescript, then
-- prettier and eslint, then the rest by name.
local extras = {
  { "lang.typescript", needs = { "node" } },
  { "formatting.prettier", needs = { "node" } },
  { "linting.eslint", needs = { "node" } },
  -- astro imports lang.typescript itself.
  { "lang.astro", needs = { "node" } },
  { "lang.go", needs = { "go" } },
  { "lang.json", needs = { "node" } },
  { "lang.markdown", needs = { "node" } },
  -- pyright, the default server, installs through npm.
  { "lang.python", needs = { "python", "node" } },
  { "lang.ruby", needs = { "ruby" } },
  { "lang.rust", needs = { "cargo" } },
  { "lang.sql", needs = { "python" } },
  { "lang.tailwind", needs = { "node" } },
  { "lang.yaml", needs = { "node" } },
}

local ok, machine = pcall(require, "config.machine")
local disabled_extras = ok and machine.disabled_extras or {}

return vim.tbl_map(function(extra)
  local name = extra[1]
  return {
    import = "lazyvim.plugins.extras." .. name,
    cond = function()
      if vim.tbl_contains(disabled_extras, name) then return false end
      for _, toolchain in ipairs(extra.needs) do
        if not toolchain_available[toolchain]() then return false end
      end
      return true
    end,
  }
end, extras)
