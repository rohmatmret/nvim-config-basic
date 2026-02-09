# Neovim Configuration for Full-Stack Development

A production-grade Neovim configuration optimized for **Go**, **TypeScript/JavaScript**, and **Vue.js** development. Built with lazy-loaded plugins for fast startup (~50ms) and a clean, modular architecture.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Architecture Overview](#architecture-overview)
- [Plugin Manager](#plugin-manager---lazynvim)
- [Core Configuration](#core-configuration)
- [Plugins by Category](#plugins-by-category)
  - [LSP & Development Tools](#lsp--development-tools)
  - [Autocompletion & Snippets](#autocompletion--snippets)
  - [Fuzzy Finder (Telescope)](#fuzzy-finder---telescope)
  - [Git Integration](#git-integration)
  - [Treesitter (Syntax)](#treesitter---syntax-highlighting--text-objects)
  - [UI & Theme](#ui--theme)
  - [Editor Enhancements](#editor-enhancements)
- [Key Mappings Reference](#key-mappings-reference)
- [Language Support Details](#language-support-details)
- [Customization](#customization)

---

## Requirements

| Dependency | Purpose |
|------------|---------|
| [Neovim](https://neovim.io/) >= 0.10 | Editor (required) |
| [Git](https://git-scm.com/) | Plugin management, git integration |
| [Nerd Font](https://www.nerdfonts.com/) | Icons in UI (Hack Nerd Font recommended) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live grep, `:grep` backend |
| [fd](https://github.com/sharkdp/fd) | Telescope file finder (optional, faster) |
| [Node.js](https://nodejs.org/) | Required by TypeScript/ESLint/Prettier LSPs |
| [Go](https://go.dev/) | Required by gopls, Go tooling |
| [LazyGit](https://github.com/jesseduffield/lazygit) | Terminal-based Git UI (optional) |

---

## Installation

1. **Back up your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository**:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   On first launch, [lazy.nvim](#plugin-manager---lazynvim) will auto-bootstrap and install all plugins. Mason will then auto-install the configured LSP servers, formatters, and linters.

4. **Verify health**:
   ```vim
   :checkhealth
   ```

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - sets leader keys and loads modules
├── lazy-lock.json              # Plugin version lock file (auto-generated)
├── CHEATSHEET.md               # Keybinding quick reference
└── lua/
    ├── config/                 # Core configuration
    │   ├── lazy.lua            # Plugin manager bootstrap & settings
    │   ├── options.lua         # Neovim editor options (tabs, search, UI)
    │   ├── keymaps.lua         # Global key mappings (non-plugin)
    │   ├── autocmds.lua        # Auto-commands (format on save, highlight yank, etc.)
    │   ├── icons.lua           # Icon definitions with Nerd Font / ASCII fallback
    │   └── fonts.lua           # Font setup guide and recommendations
    └── plugins/                # Plugin specifications (one file per category)
        ├── lsp.lua             # LSP servers, formatting (conform), linting (nvim-lint)
        ├── completion.lua      # nvim-cmp, LuaSnip, autopairs, lspkind
        ├── telescope.lua       # Fuzzy finder, pickers, extensions
        ├── git.lua             # gitsigns, diffview, lazygit, neogit, git-conflict
        ├── treesitter.lua      # Syntax highlighting, incremental selection, text objects
        ├── ui.lua              # Theme, statusline, bufferline, dashboard, notifications
        └── editor.lua          # Neo-tree, which-key, flash, surround, comments, etc.
```

Each file in `lua/plugins/` returns a table of [lazy.nvim plugin specs](https://lazy.folke.io/spec). This modular layout means you can add, remove, or modify plugin categories independently.

---

## Architecture Overview

The configuration loads in a specific order defined in [`init.lua`](init.lua):

```
1. Set leader keys         →  <Space> (leader), \ (local leader)
2. Load config/options     →  Editor settings (line numbers, tabs, search, etc.)
3. Load config/keymaps     →  Global key mappings (window nav, buffer ops, etc.)
4. Load config/autocmds    →  Autocommands (yank highlight, trailing whitespace, etc.)
5. Load config/icons       →  Icon system with Nerd Font detection and ASCII fallback
6. Load config/lazy        →  Bootstrap lazy.nvim, discover & load all plugins
```

**Lazy loading strategy**: Plugins default to `lazy = true` and load on demand via:

| Trigger | Example | Plugins |
|---------|---------|---------|
| `event` | `BufReadPre`, `VeryLazy` | LSP, treesitter, gitsigns, completion |
| `cmd` | `:Telescope`, `:Neotree` | Telescope, Neo-tree, Mason |
| `keys` | `<leader>gg` | LazyGit, flash, diffview |
| `ft` | `lua` | lazydev.nvim |

This keeps startup under ~50ms while providing full functionality once you open a file.

---

## Plugin Manager - lazy.nvim

**Config file**: [`lua/config/lazy.lua`](lua/config/lazy.lua)

[lazy.nvim](https://github.com/folke/lazy.nvim) is a modern plugin manager that auto-bootstraps on first run. Key settings in this config:

- **Auto-install**: Downloads itself if not present at `~/.local/share/nvim/lazy/lazy.nvim`
- **Default lazy loading**: All plugins are lazy-loaded unless they opt out
- **Module caching**: Enabled for faster Lua module resolution
- **Disabled built-ins**: `gzip`, `matchit`, `matchparen`, `netrwPlugin`, `tarPlugin`, `tohtml`, `tutor`, `zipPlugin` are disabled to avoid conflicts and improve startup
- **Update checker**: Checks for plugin updates once daily (non-blocking notification)

Open the plugin manager UI with `:Lazy`.

---

## Core Configuration

### Options ([`lua/config/options.lua`](lua/config/options.lua))

| Category | Settings |
|----------|----------|
| **Line numbers** | Absolute + relative line numbers enabled |
| **Indentation** | 4 spaces default; auto-adjusted per filetype (see [Autocommands](#autocommands)) |
| **Search** | Smart case, incremental search, `ripgrep` as grep backend |
| **UI** | True color, sign column always visible, cursor line highlighted |
| **Performance** | `updatetime = 200ms`, `timeoutlen = 300ms` |
| **Completion** | Popup menu height 10, slight transparency (`pumblend = 10`) |
| **Folding** | Treesitter-based fold expressions, folds open by default |
| **Splits** | New splits open below and to the right |
| **Clipboard** | Synced with system clipboard (`unnamedplus`) |

### Key Mappings ([`lua/config/keymaps.lua`](lua/config/keymaps.lua))

Leader key is **`<Space>`**. See the full [Key Mappings Reference](#key-mappings-reference) section below, or refer to [`CHEATSHEET.md`](CHEATSHEET.md) for a printable reference.

### Autocommands ([`lua/config/autocmds.lua`](lua/config/autocmds.lua))

| Autocommand | What It Does |
|-------------|-------------|
| **YankHighlight** | Briefly highlights yanked text (200ms) |
| **ResizeSplits** | Equalizes window sizes when terminal is resized |
| **LastPosition** | Restores cursor to last position when reopening a file |
| **CloseWithQ** | Allows `q` to close help, quickfix, man pages, LSP info windows |
| **AutoCreateDir** | Creates parent directories automatically when saving a new file |
| **WrapSpell** | Enables word wrap and spell check for markdown, text, gitcommit files |
| **Indentation (Go)** | Uses tabs with 4-char width for Go and Makefiles |
| **Indentation (Web)** | Uses 2-space indent for Lua, JS, TS, Vue, JSON, YAML, HTML, CSS |
| **TrimWhitespace** | Removes trailing whitespace on save (except markdown and diff) |
| **CheckTime** | Detects external file changes when Neovim regains focus |

### Icon System ([`lua/config/icons.lua`](lua/config/icons.lua))

Provides 70+ icons for diagnostics, git, files, UI elements, and LSP completion kinds. Features:

- **Nerd Font icons** as the default with a full **ASCII fallback** for terminals without Nerd Fonts
- **Auto-detection**: Disables icons in SSH sessions without a capable terminal
- **Environment variable**: Set `NVIM_ICONS=0` to force ASCII or `NVIM_ICONS=1` to force Nerd Font
- **Toggle at runtime**: `<leader>ti` or `:IconsToggle`

---

## Plugins by Category

### LSP & Development Tools

**Config file**: [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua)

#### Language Servers (via Mason)

All servers are auto-installed by [mason.nvim](https://github.com/williamboman/mason.nvim) on first launch:

| Server | Language(s) | Key Features |
|--------|------------|--------------|
| `gopls` | Go | Inlay hints, code lenses (generate, test, tidy, vendor, vulncheck), staticcheck, gofumpt formatting, complete unimported packages |
| `ts_ls` | TypeScript, JavaScript | Inlay hints for parameters, return types, variable types, enum members |
| `eslint` | JS/TS/Vue | Auto-fix on save |
| `volar` | Vue | Single-file component support |
| `tailwindcss` | CSS utility classes | Multi-language support (HTML, JS, TS, Vue) |
| `lua_ls` | Lua | Neovim API awareness via lazydev.nvim |
| `jsonls` | JSON | Schema validation via SchemaStore |
| `yamlls` | YAML | Schema validation via SchemaStore |
| `cssls` | CSS | Standard CSS language features |
| `html` | HTML | Standard HTML language features |

#### Formatting ([conform.nvim](https://github.com/stevearc/conform.nvim))

Formatting runs automatically on save. Configured formatters:

| Language | Formatter(s) |
|----------|-------------|
| Go | `goimports` (import management) + `gofumpt` (strict formatting) |
| JS/TS/Vue/CSS/HTML/JSON/YAML/Markdown | `prettier` |
| Lua | `stylua` |

#### Linting ([nvim-lint](https://github.com/mfussenegger/nvim-lint))

Linting runs on `BufWritePost` and `BufReadPost`:

| Language | Linter |
|----------|--------|
| Go | `staticcheck` |
| JS/TS/Vue | `eslint` |

#### Diagnostics Display

Diagnostics appear as:
- **Signs in the gutter**: Error, Warn, Hint, Info (with Nerd Font icons)
- **Virtual text**: Inline with `●` prefix
- **Float window**: `<leader>e` to show diagnostic details at cursor
- **Trouble panel**: `<leader>xx` for a project-wide diagnostics list

#### Other LSP Plugins

| Plugin | Purpose |
|--------|---------|
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | Displays LSP progress indicators (e.g., "gopls: loading packages...") |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Adds Neovim Lua API type information for `lua_ls` completion |

---

### Autocompletion & Snippets

**Config file**: [`lua/plugins/completion.lua`](lua/plugins/completion.lua)

Built on [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with these completion sources (in priority order):

| Source | Priority | What It Provides |
|--------|----------|-----------------|
| `cmp-nvim-lsp` | 1000 | LSP-powered completions (functions, types, variables) |
| `cmp_luasnip` | 750 | Snippet expansions |
| `cmp-buffer` | 500 | Words from open buffers (min 3 chars to activate) |
| `cmp-path` | 250 | File system paths |

**Key behaviors**:

- **Super-Tab**: `<Tab>` cycles through completions, expands snippets, or falls back to normal tab
- **Explicit confirm**: `<CR>` only confirms if an item is explicitly selected (no accidental completions)
- **Command-line completion**: Active for both `:` commands and `/` search
- **Autopairs integration**: Auto-inserts closing brackets/quotes, integrated with cmp confirm

**Snippet engine**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip) with community snippets from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets). Navigate placeholders with `<C-l>` (next) and `<C-h>` (previous).

**Completion UI**: VSCode-like icons via [lspkind.nvim](https://github.com/onsails/lspkind.nvim), bordered windows with documentation preview.

---

### Fuzzy Finder - Telescope

**Config file**: [`lua/plugins/telescope.lua`](lua/plugins/telescope.lua)

[Telescope](https://github.com/nvim-telescope/telescope.nvim) is the primary interface for finding files, searching text, navigating symbols, and more.

| Mapping | Action |
|---------|--------|
| `<leader>ff` | Find files in project |
| `<leader>fr` | Recently opened files |
| `<leader>fb` / `<leader><space>` | List open buffers |
| `<leader>sg` | Live grep across project (ripgrep) |
| `<leader>sw` | Search word under cursor |
| `<leader>ss` | Search within current buffer |
| `<leader>ls` / `<leader>lS` | Document / workspace symbols |
| `<leader>ld` / `<leader>lD` | Document / workspace diagnostics |
| `<leader>gc` / `<leader>gb` / `<leader>gs` | Git commits / branches / status |
| `<leader>fh` | Help tags |
| `<leader>fk` | Search all keymaps |
| `<leader>f.` | Resume last Telescope search |

**Extensions**:
- [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - FZF algorithm (C compiled) for faster sorting
- [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim) - Replaces `vim.ui.select` with Telescope picker

---

### Git Integration

**Config file**: [`lua/plugins/git.lua`](lua/plugins/git.lua)

Five complementary Git plugins provide a complete Git workflow:

| Plugin | Purpose | Key Mappings |
|--------|---------|-------------|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Gutter signs for changed lines, hunk staging/resetting, inline blame | `]h`/`[h` (navigate hunks), `<leader>hs` (stage), `<leader>hr` (reset), `<leader>hb` (blame) |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Full-featured Git TUI in a floating terminal | `<leader>gg` (open), `<leader>gf` (file history) |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Side-by-side diff viewer, file history browser | `<leader>gd` (open), `<leader>gD` (close), `<leader>gh` (file history) |
| [neogit](https://github.com/NeogitOrg/neogit) | Magit-like Git interface with staging, committing, and more | `<leader>gn` |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | Visual conflict markers with one-key resolution | `co` (ours), `ct` (theirs), `cb` (both), `]x`/`[x` (navigate conflicts) |

---

### Treesitter - Syntax Highlighting & Text Objects

**Config file**: [`lua/plugins/treesitter.lua`](lua/plugins/treesitter.lua)

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) provides parser-based syntax highlighting, indentation, and text objects.

**Installed parsers**: `go`, `gomod`, `gosum`, `gowork`, `javascript`, `typescript`, `tsx`, `vue`, `html`, `css`, `scss`, `json`, `yaml`, `lua`, `bash`, `markdown`, `markdown_inline`, `gitcommit`, `diff`, `regex`, `vim`, `vimdoc`, `query`

**Features**:

| Feature | Plugin | Description |
|---------|--------|-------------|
| Syntax highlighting | nvim-treesitter | Accurate, parser-based highlighting for all installed languages |
| Indentation | nvim-treesitter | Smart indentation based on syntax tree |
| Text objects | nvim-treesitter-textobjects | Select/move/swap functions (`af`/`if`), classes (`ac`/`ic`), parameters (`aa`/`ia`) |
| Sticky context | nvim-treesitter-context | Shows the current function/class header at the top of the screen (toggle: `<leader>tc`) |
| Auto-close tags | nvim-ts-autotag | Auto-closes and auto-renames HTML/JSX/Vue tags |
| Context comments | nvim-ts-context-commentstring | Correct comment syntax in embedded languages (e.g., JSX inside JS) |
| Incremental selection | nvim-treesitter | `<C-space>` to incrementally expand selection by syntax node |

---

### UI & Theme

**Config file**: [`lua/plugins/ui.lua`](lua/plugins/ui.lua)

| Plugin | What It Does |
|--------|-------------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (Storm style). Switch variant: `:colorscheme tokyonight-{storm,moon,night,day}`. Includes custom Go semantic highlights (cyan interfaces, blue structs, bold methods). |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline showing mode, branch, diagnostics, filetype, LSP clients, git diff, cursor position, and time. Uses global statusline (single bar at bottom). |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Tab-like buffer bar at the top. Shows diagnostics count per buffer, supports pinning and grouping. |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Vertical indent guide lines with scope highlighting. |
| [noice.nvim](https://github.com/folke/noice.nvim) | Replaces the default command line, messages, and notifications with a modern UI. Search appears at the bottom, long messages open in a split. |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Animated notification popups (replaces `vim.notify`). Compact style, 3-second timeout. |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | Better looking `vim.ui.input` and `vim.ui.select` dialogs. |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard on startup with ASCII art header and quick-access buttons (find file, recent files, grep, config, lazy, quit). |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File-type icons throughout the UI. Includes custom Go-specific icons (go.mod, go.sum, Makefile, Dockerfile). |

---

### Editor Enhancements

**Config file**: [`lua/plugins/editor.lua`](lua/plugins/editor.lua)

| Plugin | Purpose | Key Usage |
|--------|---------|-----------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar (35 char width, left side). Dims Go vendor/ and generated files. | `<leader>e` toggle, `<leader>E` reveal current file |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Popup showing available keybindings after pressing a prefix key. | Press `<leader>` and wait to see all options |
| [flash.nvim](https://github.com/folke/flash.nvim) | Quick cursor navigation with labeled jump targets. Treesitter-aware. | `s` jump, `S` treesitter select |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Add/change/delete surrounding characters (quotes, brackets, tags). | `ys{motion}{char}`, `ds{char}`, `cs{old}{new}` |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Toggle line/block comments. Context-aware for embedded languages. | `gcc` line, `gbc` block, `gc` with motion |
| [mini.ai](https://github.com/echasnovski/mini.ai) | Extended text objects for blocks, conditionals, loops, and more. | `vio` inside block, `vao` around block |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics panel with project-wide error/warning listing. | `<leader>xx` workspace, `<leader>xX` buffer |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights and searches TODO/FIXME/HACK comments. | `]t`/`[t` navigate, `<leader>ft` find all |
| [marks.nvim](https://github.com/chentoast/marks.nvim) | Enhanced marks display with gutter signs and bookmarks. | Standard `m{a-z}` marks, `<leader>fm` to list |

---

## Key Mappings Reference

> Leader: `<Space>` | Local Leader: `\`

### General

| Mapping | Mode | Action |
|---------|------|--------|
| `jk` / `jj` | Insert | Exit insert mode |
| `<C-s>` | Normal/Insert | Save file |
| `<Esc>` | Normal | Clear search highlight |
| `<leader>qq` | Normal | Quit all |

### Window Management

| Mapping | Action |
|---------|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-Up/Down/Left/Right>` | Resize windows |
| `<leader>wv` | Vertical split |
| `<leader>ws` | Horizontal split |
| `<leader>wc` | Close window |

### Buffers

| Mapping | Action |
|---------|--------|
| `<S-h>` / `<S-l>` | Previous / Next buffer |
| `<leader>bd` | Close buffer |
| `<leader>bp` | Pin buffer |
| `<leader>bo` | Close all other buffers |

### LSP

| Mapping | Action |
|---------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format document |
| `<leader>th` | Toggle inlay hints |

### Search (Telescope)

| Mapping | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>sg` | Live grep |
| `<leader>fr` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>f.` | Resume last search |

### Git

| Mapping | Action |
|---------|--------|
| `<leader>gg` | Open LazyGit |
| `<leader>gn` | Open Neogit |
| `<leader>gd` | Open Diffview |
| `]h` / `[h` | Next / previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Blame line |

For the full keybinding reference, see [`CHEATSHEET.md`](CHEATSHEET.md).

---

## Language Support Details

### Go

This config has deep Go integration through `gopls`:

- **Formatting**: `goimports` (auto-manages imports) + `gofumpt` (stricter `gofmt`) on every save
- **Linting**: `staticcheck` for advanced static analysis
- **Code lenses**: Run tests, generate code, tidy modules, check vulnerabilities, upgrade dependencies, vendor
- **Inlay hints**: Parameter names, variable types, composite literal fields, constant values (toggle with `<leader>th`)
- **Analyses**: Field alignment, nilness, unused params/writes, `any` usage
- **Semantic highlighting**: Interfaces (cyan italic), structs (blue), methods (blue bold), parameters (yellow)
- **Neo-tree**: Vendor directory and generated files (`.pb.go`, `_gen.go`) are visually dimmed

### TypeScript / JavaScript

- **LSP**: `ts_ls` with full inlay hints (parameters, return types, variable types, enum members)
- **Linting**: ESLint with auto-fix on save
- **Formatting**: Prettier on save
- **JSX/TSX**: Auto-close and auto-rename tags, context-aware commenting

### Vue

- **LSP**: Volar (`vue-language-server`)
- **Formatting**: Prettier
- **Linting**: ESLint
- **Treesitter**: Full SFC (single-file component) parsing

### Lua

- **LSP**: `lua_ls` with Neovim API awareness (via `lazydev.nvim`)
- **Formatting**: `stylua`

### JSON / YAML

- **LSP**: `jsonls` / `yamlls` with schema validation from [SchemaStore](https://www.schemastore.org/)
- **Formatting**: Prettier

---

## Customization

### Adding a New Plugin

Create a new file or add to an existing file in `lua/plugins/`:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- or "BufReadPre", cmd = "PluginCmd", keys = { ... }
    opts = {
      -- plugin options
    },
  },
}
```

lazy.nvim auto-discovers all files in `lua/plugins/`.

### Adding a New LSP Server

1. Add the server name to the `ensure_installed` list in [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua) (under Mason config)
2. Add server-specific settings in the `servers` table in the same file
3. Restart Neovim - Mason will auto-install the server

### Changing the Colorscheme

In [`lua/plugins/ui.lua`](lua/plugins/ui.lua), modify the tokyonight config or replace it with another colorscheme. Available tokyonight variants:

```vim
:colorscheme tokyonight-storm   " Default - blue-gray
:colorscheme tokyonight-moon    " Balanced contrast
:colorscheme tokyonight-night   " Darkest
:colorscheme tokyonight-day     " Light theme
```

### Changing Keybindings

- **Global mappings**: Edit [`lua/config/keymaps.lua`](lua/config/keymaps.lua)
- **Plugin-specific mappings**: Edit the `keys` table in the relevant plugin file under `lua/plugins/`
- **Discover existing mappings**: Press `<leader>fk` to search all keymaps with Telescope

### SSH / Remote Usage

The icon system auto-detects limited terminals and falls back to ASCII. Override with:

```bash
export NVIM_ICONS=0   # Force ASCII mode
export NVIM_ICONS=1   # Force Nerd Font icons
```

---

## Useful Commands

```vim
:Lazy                " Plugin manager UI
:Mason               " LSP/formatter/linter installer
:LspInfo             " Show active LSP servers
:ConformInfo         " Show active formatters
:IconsToggle         " Toggle Nerd Font / ASCII icons
:FontInfo            " Font configuration info
:checkhealth         " Diagnose issues
:Telescope keymaps   " Search all keymaps
```

---

## Credits

Built with these projects:

- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP/tool installer
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Colorscheme
