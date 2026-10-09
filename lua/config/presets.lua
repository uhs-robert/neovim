-- lua/config/presets.lua
-- Named bundles of per-machine opt-outs, picked in lua/config/machine.lua with preset = "<name>".
-- A preset takes the same lists as machine.lua; the machine's own lists are added on top.
return {
  -- Servers and remote sessions: no animation, which repaints the whole screen over the wire, and
  -- no color eye candy.
  minimal = {
    disabled_groups = { "fun", "visual" },
    disabled_plugins = { "neoscroll.nvim" },
  },
}
