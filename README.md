<p align="center">
  <img
    src="https://raw.githubusercontent.com/uhs-robert/oasis-dots/assets/logo.png"
    width="auto" height="128" alt="Oasis logo" />
</p>
<h1 align="center">neovim</h1>
<p align="center">
  <a href="https://github.com/uhs-robert/neovim/stargazers"><img src="https://img.shields.io/github/stars/uhs-robert/neovim?colorA=192330&colorB=khaki&style=for-the-badge&cacheSeconds=4300" alt="Stargazers"></a>
  <a href="https://github.com/uhs-robert/neovim/issues"><img src="https://img.shields.io/github/issues/uhs-robert/neovim?colorA=192330&colorB=skyblue&style=for-the-badge&cacheSeconds=4300" alt="Issues"></a>
  <a href="https://discord.gg/b7y5CGVGTB"><img src="https://img.shields.io/discord/1554625284068741140?label=discord&logo=discord&logoColor=white&colorA=192330&colorB=5865F2&style=for-the-badge&cacheSeconds=4300" alt="Discord"></a>
</p>
<p align="center">My Neovim config: LazyVim underneath, Oasis on top, at home on Linux and Windows.</p>

## 🖥️ Overview

This is the editor half of [oasis-dots](https://github.com/uhs-robert/oasis-dots) and
[oasis-dots-windows](https://github.com/uhs-robert/oasis-dots-windows). It starts from
[LazyVim](https://www.lazyvim.org) and keeps its keys, then adds what I use every day:

- **A colorscheme that tells you where you are.** [Oasis](https://github.com/uhs-robert/oasis.nvim)
  by default, the scorched Scorpion variant as root or under `sudoedit`, teal Mirage inside an SSHFS
  mount, and a night variant after dark. On Linux it follows the desktop's palette when the dotfiles sync it.
- **Remote work without leaving the editor.** [sshfs.nvim](https://github.com/uhs-robert/sshfs.nvim)
  mounts a server, opens it in the picker or [yazi](https://github.com/sxyazi/yazi), and can search it
  live over SSH.
- **Languages per machine.** Each language only loads where its toolchain is installed,
  so a box without Node never tries to install a TypeScript server. An untracked `machine.lua` turns
  off anything else a minimal machine doesn't want.
- **One config, two systems.** The same repo is linked into `~/.config/nvim` on Linux and
  `%LOCALAPPDATA%\nvim` on Windows.

## 📦 Install

You need Neovim **0.12** or newer (nvim-treesitter's `main` branch requires it), git, a
[Nerd Font](https://www.nerdfonts.com), and for building treesitter parsers the
[tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) and a C compiler (`cc`, gcc or MSVC).
ripgrep, fd, lazygit and yazi are used when they are there.

With my dotfiles, there is nothing to do: oasis-dots and oasis-dots-windows clone this repo and link
it for you. On its own:

```sh
# Linux / macOS
git clone https://github.com/uhs-robert/neovim ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/uhs-robert/neovim "$env:LOCALAPPDATA\nvim"
```

To try it without replacing your own config, clone it anywhere under `~/.config` and point
`NVIM_APPNAME` at it:

```sh
git clone https://github.com/uhs-robert/neovim ~/.config/uhs-nvim
NVIM_APPNAME=uhs-nvim nvim
```

The first start installs every plugin, then Mason installs the language servers in the background.

## 🌐 Per-Machine Settings

Language extras whose tools Mason installs through a toolchain (npm, pip, go, gem, cargo) only load
on machines that have that toolchain. Without Node, for example, TypeScript, Astro, JSON, YAML,
Markdown and Tailwind are skipped. The list and what each one needs is in
[`lua/config/language_extras.lua`](lua/config/language_extras.lua). Extras that need no toolchain,
such as PHP, TOML and git, are in [`lazyvim.json`](lazyvim.json) and load everywhere.

To trim a machine further, for example to keep a server minimal, create `lua/config/machine.lua`
(git ignores it) and restart Neovim. Most machines only need a preset:

```lua
return { preset = "minimal" }
```

Presets live in [`lua/config/presets.lua`](lua/config/presets.lua). `minimal` drops the animation
and color eye candy (the `fun` and `visual` groups and smooth scrolling). Anything else can be
listed alongside it, and adds to the preset:

```lua
return {
  preset = "minimal",
  -- whole files in lua/plugins/, by name (the groups in the plugin list below)
  disabled_groups = { "remote" },
  -- language extras to skip even though their toolchain is installed
  disabled_extras = { "lang.astro", "lang.tailwind" },
  -- any single plugin, by the name :Lazy shows for it
  disabled_plugins = { "tiny-glimmer.nvim" },
}
```

Any group can be switched off: its own plugins go, while its settings for plugins LazyVim installs
anyway (lualine in `theme`, treesitter in `editor`) still apply. Turning off `theme` does remove the
Oasis colorscheme itself, though. Extra names drop the `lazyvim.plugins.extras.` prefix. An unknown
preset or group name shows a warning at startup, but a misspelled plugin name is silently ignored,
so copy it from `:Lazy`. Mason keeps tools it already installed; remove them from `:Mason` with `X`.

## 🎨 Colorschemes

The scheme is picked when Neovim starts, first match wins:

| When                                          | Scheme           |
| --------------------------------------------- | ---------------- |
| Running as root, or under `sudoedit`          | `oasis-scorpion` |
| The working directory is under `~/mnt/`       | `oasis-mirage`   |
| The dotfiles synced a scheme from the palette | that scheme      |
| Otherwise                                     | `oasis`          |

While Neovim is open, [color-chameleon.nvim](https://github.com/uhs-robert/color-chameleon.nvim)
re-checks the root and `~/mnt/` rules whenever you change directory, open a buffer or start a
terminal, switches to `oasis-night` after dark (earlier in winter, later in summer), and falls back
to `oasis` otherwise. `<leader>Cl` steps a light Oasis style through its intensity levels 1 to 5.

## ⌨️ Keys

Leader is `Space`, and every [LazyVim key](https://www.lazyvim.org/keymaps) works as documented.
On top of those:

| Keys                | Does                                                                |
| ------------------- | ------------------------------------------------------------------- |
| `Ctrl+h/j/k/l`      | Move between splits, and on into tmux panes past the edge           |
| `w` / `e` / `b`     | Move by subword: `camelCase` and `snake_case` parts count as words  |
| `<leader>cd`        | Change directory to the current file's folder                       |
| `<leader>fs`        | Save without running the formatter                                  |
| `<leader>gC`        | Clone a git repo and change into it                                 |
| `<leader>rn`        | Rename the symbol under the cursor, previewed as you type           |
| `<leader>uy` / `uY` | Toggle the filename comment at the top of files (all / this buffer) |
| `<leader>Cl`        | Step a light Oasis style's intensity (1 to 5)                       |

`<leader>` then a pause shows every bind in [which-key](https://github.com/folke/which-key.nvim).

## 🧩 Plugins

Plugins this config adds on top of LazyVim and its extras, grouped by the file in
[`lua/plugins/`](lua/plugins) that sets them up. This list is generated by
[`scripts/readme_plugins.lua`](scripts/readme_plugins.lua); edit the specs, not the list.

<!-- plugins:start -->

- **Coding:** [mini.align](https://github.com/nvim-mini/mini.align)
- **Editor:** [mdx.nvim](https://github.com/davidmh/mdx.nvim), [pretty-fold.nvim](https://github.com/anuvyklack/pretty-fold.nvim), [nvim-spider](https://github.com/chrisgrieser/nvim-spider), [nvim-various-textobjs](https://github.com/chrisgrieser/nvim-various-textobjs)
- **Filetypes:** [yuck.vim](https://github.com/elkowar/yuck.vim), [vim-tridactyl](https://github.com/tridactyl/vim-tridactyl)
- **Fun:** [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim), [tiny-glimmer.nvim](https://github.com/rachartier/tiny-glimmer.nvim)
- **Git:** [diffview.nvim](https://github.com/sindrets/diffview.nvim), [open-github-url.nvim](https://github.com/tetzng/open-github-url.nvim)
- **LSP:** [goto-preview](https://github.com/rmagatti/goto-preview)
- **Navigation:** [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), [minty](https://github.com/nvzone/minty), [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim), [nvim-rooter.lua](https://github.com/notjedi/nvim-rooter.lua), [yazi.nvim](https://github.com/mikavilpas/yazi.nvim)
- **Remote:** [sshfs.nvim](https://github.com/uhs-robert/sshfs.nvim)
- **Theme:** [color-chameleon.nvim](https://github.com/uhs-robert/color-chameleon.nvim), [oasis.nvim](https://github.com/uhs-robert/oasis.nvim), [jewel.nvim](https://github.com/uhs-robert/jewel.nvim), [tabby.nvim](https://github.com/nanozuki/tabby.nvim)
- **Utility:** [color-converter.nvim](https://github.com/NTBBloodbath/color-converter.nvim), [comment-filename.nvim](https://github.com/uhs-robert/comment-filename.nvim)
- **Visual:** [colorful-menu.nvim](https://github.com/xzbdmw/colorful-menu.nvim), [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors)

<!-- plugins:end -->

## 🗂️ Layout

```text
init.lua                     leader, local plugin paths, then lazy.nvim
lazyvim.json                 LazyVim extras that load everywhere
lua/config/                  options, keymaps, autocmds, lazy.nvim setup
lua/config/language_extras.lua   language extras gated on toolchains
lua/plugins/                 one file per area (theme, editor, git, navigation, remote, ...)
after/, ftplugin/, spell/    filetype tweaks, treesitter queries, spelling dictionary
scripts/readme_plugins.lua   regenerates the plugin list in this README
.githooks/pre-commit         runs it when a commit touches lua/plugins/
```

The hook only runs once it is enabled in your clone:

```sh
git config core.hooksPath .githooks
```

## 🔗 Make It Yours

Fork it, then:

1. Change `DEV_USER` and `GITHUB_PATH` in `init.lua` to where you keep plugin checkouts. Plugins
   wrapped in `local_plugin("name")` load from there when the folder exists, and from GitHub when it
   doesn't, which is handy when you develop plugins of your own.
2. Swap the colorscheme rules in `lua/plugins/core.lua` and `lua/plugins/theme.lua`.
3. Toggle LazyVim extras with `:LazyExtras`, or add toolchain-backed ones to
   `lua/config/language_extras.lua`.

Like it? Give it a star, or [buy me a coffee](https://ko-fi.com/uphillsolutions).
