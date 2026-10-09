-- lua/config/extras.lua
-- Every LazyVim extra this config uses. They live here rather than in lazyvim.json because
-- LazyVim also writes per-machine state into that file (news it has shown), so it is git-ignored.
--
-- Extras with `needs` are only imported where that toolchain exists, so Mason never tries to
-- install a server it has no runtime for. To skip any extra on a single machine, list it under
-- disabled_extras in the untracked lua/config/machine.lua (see lua/config/machine_settings.lua).
--
-- blink, snacks_explorer and snacks_picker are not listed: LazyVim enables its default completion,
-- explorer and picker extras itself.

local IS_WINDOWS = vim.fn.has("win32") == 1

-- Windows puts python.exe stubs under WindowsApps that only open the Microsoft Store.
local function has(executable)
  local path = vim.fn.exepath(executable)
  return path ~= "" and not (IS_WINDOWS and path:find("WindowsApps", 1, true) ~= nil)
end

local toolchain_available = {
  node = function()
    return has("node")
  end,
  python = function()
    return has("python3") or has("python")
  end,
  go = function()
    return has("go")
  end,
  ruby = function()
    return has("ruby")
  end,
  cargo = function()
    return has("cargo")
  end,
}

-- Ordered as LazyVim's own loader would (lazyvim/plugins/xtras.lua): test.core before anything
-- that registers test adapters, typescript before prettier and eslint, the rest by name.
local extras = {
  { "test.core" },
  { "ai.sidekick" },
  { "coding.mini-comment" },
  { "coding.mini-surround" },
  { "coding.yanky" },
  { "editor.dial" },
  { "editor.illuminate" },
  { "editor.inc-rename" },
  { "editor.mini-move" },
  { "lang.git" },
  { "lang.php" },
  { "lang.toml" },
  { "ui.mini-indentscope" },
  { "ui.treesitter-context" },
  { "util.dot" },
  { "util.mini-hipatterns" },
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

local disabled_extras = require("config.machine_settings").disabled_extras

return vim.tbl_map(function(extra)
  local name = extra[1]
  return {
    import = "lazyvim.plugins.extras." .. name,
    cond = function()
      if vim.tbl_contains(disabled_extras, name) then return false end
      for _, toolchain in ipairs(extra.needs or {}) do
        if not toolchain_available[toolchain]() then return false end
      end
      return true
    end,
  }
end, extras)
