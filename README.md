# neovim/

<a href="https://dotfyle.com/uhs-robert/nvim-config"><img src="https://dotfyle.com/uhs-robert/nvim-config/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/uhs-robert/nvim-config"><img src="https://dotfyle.com/uhs-robert/nvim-config/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/uhs-robert/nvim-config"><img src="https://dotfyle.com/uhs-robert/nvim-config/badges/plugin-manager?style=for-the-badge" /></a>

## Install Instructions

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:uhs-robert/nvim-config ~/.config/uhs-robert/nvim-config
```

Open Neovim with this config:

```sh
NVIM_APPNAME=uhs-robert/nvim-config/ nvim
```

## Languages per machine

Language extras whose tools Mason installs through a toolchain (npm, pip, go, gem, cargo) only load
on machines that have that toolchain. Without Node, for example, TypeScript, Astro, JSON, YAML,
Markdown and Tailwind are skipped. The list and what each one needs is in
[`lua/config/language_extras.lua`](lua/config/language_extras.lua).

To turn one off on a single machine even though its toolchain is there, create
`lua/config/machine.lua` (git ignores it) and restart Neovim:

```lua
return { disabled_extras = { "lang.astro", "lang.tailwind" } }
```

Names are the extra without its `lazyvim.plugins.extras.` prefix. Mason keeps tools it already
installed; remove them from `:Mason` with `X`.

## Plugins

### ai

- [folke/sidekick.nvim](https://dotfyle.com/plugins/folke/sidekick.nvim)

### color

- [brenoprata10/nvim-highlight-colors](https://dotfyle.com/plugins/brenoprata10/nvim-highlight-colors)
- [xzbdmw/colorful-menu.nvim](https://dotfyle.com/plugins/xzbdmw/colorful-menu.nvim)
- [nvzone/minty](https://dotfyle.com/plugins/nvzone/minty)

### colorscheme

- [kungfusheep/mfd.nvim](https://dotfyle.com/plugins/kungfusheep/mfd.nvim)
- [uhs-robert/oasis.nvim](https://dotfyle.com/plugins/uhs-robert/oasis.nvim)
- [uhs-robert/color-chameleon.nvim](https://dotfyle.com/plugins/uhs-robert/color-chameleon.nvim)

### coding

- [nvim-mini/mini.align](https://dotfyle.com/plugins/nvim-mini/mini.align)

### editing-support

- [anuvyklack/pretty-fold.nvim](https://dotfyle.com/plugins/anuvyklack/pretty-fold.nvim)
- [chrisgrieser/nvim-various-textobjs](https://dotfyle.com/plugins/chrisgrieser/nvim-various-textobjs)
- [folke/snacks.nvim](https://dotfyle.com/plugins/folke/snacks.nvim)

### file-explorer

- [mikavilpas/yazi.nvim](https://dotfyle.com/plugins/mikavilpas/yazi.nvim)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### fun

- [jackplus-xyz/player-one.nvim](https://dotfyle.com/plugins/jackplus-xyz/player-one.nvim)
- [nvzone/typr](https://dotfyle.com/plugins/nvzone/typr)
- [rachartier/tiny-glimmer.nvim](https://dotfyle.com/plugins/rachartier/tiny-glimmer.nvim)

### fuzzy-finder

- [ibhagwan/fzf-lua](https://dotfyle.com/plugins/ibhagwan/fzf-lua)

### git

- [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)
- [sindrets/diffview.nvim](https://dotfyle.com/plugins/sindrets/diffview.nvim)
- [tetzng/open-github-url.nvim](https://dotfyle.com/plugins/tetzng/open-github-url.nvim)

### icon

- [nvim-tree/nvim-web-devicons](https://dotfyle.com/plugins/nvim-tree/nvim-web-devicons)
- [nvim-mini/mini.icons](https://dotfyle.com/plugins/nvim-mini/mini.icons)

### linting

- [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)

### lsp

- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [rmagatti/goto-preview](https://dotfyle.com/plugins/rmagatti/goto-preview)

### markdown-and-latex

- [MeanderingProgrammer/render-markdown.nvim](https://dotfyle.com/plugins/MeanderingProgrammer/render-markdown.nvim)

### motion

- [chrisgrieser/nvim-spider](https://dotfyle.com/plugins/chrisgrieser/nvim-spider)

### navigation

- [christoomey/vim-tmux-navigator](https://dotfyle.com/plugins/christoomey/vim-tmux-navigator)
- [notjedi/nvim-rooter.lua](https://dotfyle.com/plugins/notjedi/nvim-rooter.lua)
- [karb94/neoscroll.nvim](https://dotfyle.com/plugins/karb94/neoscroll.nvim)

### nvim-dev

- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
- [OXY2DEV/helpview.nvim](https://dotfyle.com/plugins/OXY2DEV/helpview.nvim)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### preconfigured

- [LazyVim/LazyVim](https://dotfyle.com/plugins/LazyVim/LazyVim)

### remote-development

- [uhs-robert/sshfs.nvim](https://dotfyle.com/plugins/uhs-robert/sshfs.nvim)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)
- [elkowar/yuck.vim](https://dotfyle.com/plugins/elkowar/yuck.vim)
- [tridactyl/vim-tridactyl](https://dotfyle.com/plugins/tridactyl/vim-tridactyl)

### tabline

- [nanozuki/tabby.nvim](https://dotfyle.com/plugins/nanozuki/tabby.nvim)

### utility

- [NTBBloodbath/color-converter.nvim](https://dotfyle.com/plugins/NTBBloodbath/color-converter.nvim)
- [uhs-robert/comment-filename.nvim](https://dotfyle.com/plugins/uhs-robert/comment-filename.nvim)

### visual

- [nvim-mini/mini.hipatterns](https://dotfyle.com/plugins/nvim-mini/mini.hipatterns)

## Language Servers

- lua_ls
- phpactor

This readme was generated by [Dotfyle](https://dotfyle.com)
