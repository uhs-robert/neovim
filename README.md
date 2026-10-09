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
  so a box without Node never tries to install a TypeScript server.
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

## 🌐 Languages Per Machine

Language extras whose tools Mason installs through a toolchain (npm, pip, go, gem, cargo) only load
on machines that have that toolchain. Without Node, for example, TypeScript, Astro, JSON, YAML,
Markdown and Tailwind are skipped. The list and what each one needs is in
[`lua/config/language_extras.lua`](lua/config/language_extras.lua). Extras that need no toolchain,
such as PHP, TOML and git, are in [`lazyvim.json`](lazyvim.json) and load everywhere.

To turn one off on a single machine even though its toolchain is there, create
`lua/config/machine.lua` (git ignores it) and restart Neovim:

```lua
return { disabled_extras = { "lang.astro", "lang.tailwind" } }
```

Names are the extra without its `lazyvim.plugins.extras.` prefix. Mason keeps tools it already
installed; remove them from `:Mason` with `X`.

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

Beyond LazyVim's defaults and the language extras:

| For               | Plugins                                                                                                                                                                                                                                                                                                                           |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Theme and UI      | [oasis.nvim](https://github.com/uhs-robert/oasis.nvim), [color-chameleon.nvim](https://github.com/uhs-robert/color-chameleon.nvim), [lualine](https://github.com/nvim-lualine/lualine.nvim), [tabby](https://github.com/nanozuki/tabby.nvim), [smear-cursor](https://github.com/sphamba/smear-cursor.nvim)                        |
| Editing           | [nvim-spider](https://github.com/chrisgrieser/nvim-spider), [various-textobjs](https://github.com/chrisgrieser/nvim-various-textobjs), [mini.align](https://github.com/nvim-mini/mini.align), [inc-rename](https://github.com/smjonas/inc-rename.nvim), [pretty-fold](https://github.com/anuvyklack/pretty-fold.nvim)             |
| Navigation        | [yazi.nvim](https://github.com/mikavilpas/yazi.nvim), [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), [nvim-rooter](https://github.com/notjedi/nvim-rooter.lua), [neoscroll](https://github.com/karb94/neoscroll.nvim)                                                                                   |
| Remote            | [sshfs.nvim](https://github.com/uhs-robert/sshfs.nvim)                                                                                                                                                                                                                                                                            |
| Git               | [gitsigns](https://github.com/lewis6991/gitsigns.nvim), [diffview](https://github.com/sindrets/diffview.nvim), [open-github-url](https://github.com/tetzng/open-github-url.nvim)                                                                                                                                                  |
| Markdown and docs | [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim), [mdx.nvim](https://github.com/davidmh/mdx.nvim), [helpview](https://github.com/OXY2DEV/helpview.nvim)                                                                                                                                            |
| Color tools       | [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors), [mini.hipatterns](https://github.com/nvim-mini/mini.hipatterns), [minty](https://github.com/nvzone/minty), [color-converter](https://github.com/NTBBloodbath/color-converter.nvim), [colorful-menu](https://github.com/xzbdmw/colorful-menu.nvim) |
| Odds and ends     | [comment-filename.nvim](https://github.com/uhs-robert/comment-filename.nvim), [yuck.vim](https://github.com/elkowar/yuck.vim), [vim-tridactyl](https://github.com/tridactyl/vim-tridactyl)                                                                                                                                        |

## 🗂️ Layout

```text
init.lua                     leader, local plugin paths, then lazy.nvim
lazyvim.json                 LazyVim extras that load everywhere
lua/config/                  options, keymaps, autocmds, lazy.nvim setup
lua/config/language_extras.lua   language extras gated on toolchains
lua/plugins/                 one file per area (theme, editor, git, navigation, remote, ...)
after/, ftplugin/, spell/    filetype tweaks, treesitter queries, spelling dictionary
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
