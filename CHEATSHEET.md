# Neovim Professional Cheatsheet

> Leader Key: `<Space>` | Local Leader: `\`

---

## Quick Reference - Most Used

| Action | Keybind | Description |
|--------|---------|-------------|
| Find files | `<leader>ff` | Fuzzy find files |
| Live grep | `<leader>sg` | Search text in project |
| File explorer | `<leader>e` | Toggle Neo-tree |
| Go to definition | `gd` | Jump to symbol definition |
| Find references | `gr` | Find all references |
| Code action | `<leader>ca` | Quick fix / refactor |
| Next error | `]d` | Jump to next diagnostic |
| Previous error | `[d` | Jump to previous diagnostic |
| Format | `<leader>cf` | Format document |
| Save | `<C-s>` | Save file |

---

## Common Workflows

### Toggle Sidebar While Editing
```
<Space>e     → Open/close sidebar
<C-h>        → Jump to sidebar (left window)
<C-l>        → Jump back to editor (right window)
```

### Switch Between Open Files
```
<S-h>        → Previous buffer (Shift + h)
<S-l>        → Next buffer (Shift + l)
<Space><Space> → List all open buffers, pick one
```

### Open Another File
```
<Space>ff    → Find file by name
<Space>fr    → Recent files
<Space>sg    → Search text in all files
```

### Close File and Return to Sidebar
```
<Space>bd    → Close current buffer
<Space>e     → Open sidebar
```

---

## Navigation

### Basic Movement
| Keybind | Description |
|---------|-------------|
| `h j k l` | Left, Down, Up, Right |
| `w` / `W` | Next word / WORD |
| `b` / `B` | Previous word / WORD |
| `e` / `E` | End of word / WORD |
| `0` / `$` | Start / End of line |
| `^` | First non-blank character |
| `gg` / `G` | Top / Bottom of file |
| `{` / `}` | Previous / Next paragraph |
| `%` | Jump to matching bracket |
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |

### Window Navigation
| Keybind | Description |
|---------|-------------|
| `<C-h>` | Go to left window |
| `<C-j>` | Go to lower window |
| `<C-k>` | Go to upper window |
| `<C-l>` | Go to right window |
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |
| `<leader>wv` | Split vertical |
| `<leader>ws` | Split horizontal |
| `<leader>wc` | Close window |
| `<leader>wo` | Close other windows |

### Buffer Navigation
| Keybind | Description |
|---------|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `[b` | Previous buffer (bufferline) |
| `]b` | Next buffer (bufferline) |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Force delete buffer |
| `<leader>bp` | Toggle pin buffer |
| `<leader>bo` | Close other buffers |
| `<leader><space>` | List buffers |

### Tab Navigation
| Keybind | Description |
|---------|-------------|
| `<leader><tab>n` | New tab |
| `<leader><tab>c` | Close tab |
| `<leader><tab>l` | Next tab |
| `<leader><tab>h` | Previous tab |

---

## LSP (Language Server Protocol)

### Code Navigation
| Keybind | Description |
|---------|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help (normal/insert) |

### Code Actions
| Keybind | Description |
|---------|-------------|
| `<leader>ca` | Code action (fix/refactor) |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format document/selection |
| `<leader>cF` | Format injected languages |
| `<leader>cm` | Open Mason (LSP installer) |

### Workspace
| Keybind | Description |
|---------|-------------|
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |

### Inlay Hints
| Keybind | Description |
|---------|-------------|
| `<leader>th` | Toggle inlay hints |

---

## Diagnostics & Errors

### Navigation
| Keybind | Description |
|---------|-------------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostic float |
| `<leader>q` | Send diagnostics to location list |

### Quickfix List
| Keybind | Description |
|---------|-------------|
| `[q` | Previous quickfix item |
| `]q` | Next quickfix item |
| `[Q` | First quickfix item |
| `]Q` | Last quickfix item |

### Trouble (Diagnostics Panel)
| Keybind | Description |
|---------|-------------|
| `<leader>xx` | Toggle workspace diagnostics |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>xs` | Toggle symbols |
| `<leader>xl` | Toggle LSP definitions |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |

---

## Telescope (Fuzzy Finder)

### File Operations
| Keybind | Description |
|---------|-------------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fb` | List buffers |
| `<leader><space>` | List buffers (alternate) |

### Search
| Keybind | Description |
|---------|-------------|
| `<leader>sg` | Live grep (search text) |
| `<leader>sw` | Search word under cursor |
| `<leader>ss` | Search in current buffer |
| `<leader>f.` | Resume last search |

### LSP via Telescope
| Keybind | Description |
|---------|-------------|
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>ld` | Document diagnostics |
| `<leader>lD` | Workspace diagnostics |

### Git via Telescope
| Keybind | Description |
|---------|-------------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |

### Misc
| Keybind | Description |
|---------|-------------|
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fc` | Commands |
| `<leader>fm` | Marks |
| `<leader>fR` | Registers |
| `<leader>ft` | Find TODOs |
| `<leader>f/` | Search history |
| `<leader>f:` | Command history |

### Inside Telescope
| Keybind | Description |
|---------|-------------|
| `<C-j>` / `<C-k>` | Move selection down/up |
| `<C-n>` / `<C-p>` | Cycle history |
| `<CR>` | Open selected |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-q>` | Send all to quickfix |
| `<M-q>` | Send selected to quickfix |
| `<Tab>` | Toggle selection |
| `<M-p>` | Toggle preview |
| `<C-d>` | Delete buffer (in buffers) |

---

## Git Integration

### Gitsigns (Hunks)
| Keybind | Description |
|---------|-------------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this ~ |
| `ih` | Select hunk (text object) |

### Toggles
| Keybind | Description |
|---------|-------------|
| `<leader>tb` | Toggle line blame |
| `<leader>td` | Toggle deleted |

### Git Tools
| Keybind | Description |
|---------|-------------|
| `<leader>gg` | Open LazyGit |
| `<leader>gf` | LazyGit current file |
| `<leader>gn` | Open Neogit |
| `<leader>gd` | Open Diffview |
| `<leader>gD` | Close Diffview |
| `<leader>gh` | File history |
| `<leader>gH` | Branch history |

### Git Conflict Resolution
| Keybind | Description |
|---------|-------------|
| `co` | Choose ours |
| `ct` | Choose theirs |
| `cb` | Choose both |
| `c0` | Choose none |
| `]x` | Next conflict |
| `[x` | Previous conflict |

---

## File Explorer (Neo-tree)

| Keybind | Description |
|---------|-------------|
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Reveal current file |

### Inside Neo-tree
| Keybind | Description |
|---------|-------------|
| `<CR>` / `o` | Open file/folder |
| `s` | Open in horizontal split |
| `v` | Open in vertical split |
| `t` | Open in new tab |
| `w` | Open with window picker |
| `C` | Close node |
| `z` | Close all nodes |
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `c` | Copy |
| `m` | Move |
| `R` | Refresh |
| `q` | Close window |
| `?` | Show help |
| `<` / `>` | Previous/Next source |

---

## Completion (nvim-cmp)

| Keybind | Description |
|---------|-------------|
| `<Tab>` | Next item / Expand snippet |
| `<S-Tab>` | Previous item |
| `<C-n>` | Next item |
| `<C-p>` | Previous item |
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |

### Snippets (LuaSnip)
| Keybind | Description |
|---------|-------------|
| `<C-l>` | Jump to next placeholder |
| `<C-h>` | Jump to previous placeholder |

---

## Editing

### Line Operations
| Keybind | Description |
|---------|-------------|
| `<A-j>` | Move line/selection down |
| `<A-k>` | Move line/selection up |
| `<` / `>` (visual) | Indent left/right (stay in visual) |
| `p` (visual) | Paste without yanking replaced text |

### Text Objects
| Keybind | Description |
|---------|-------------|
| `vif` | Select inside function |
| `vaf` | Select around function |
| `vic` | Select inside class |
| `vac` | Select around class |
| `vio` | Select inside block/conditional/loop |
| `vao` | Select around block/conditional/loop |

### Surround (nvim-surround)
| Keybind | Description |
|---------|-------------|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| Example: `ysiw"` | Surround word with `"` |
| Example: `ds'` | Delete surrounding `'` |
| Example: `cs'"` | Change `'` to `"` |

### Comments (Comment.nvim)
| Keybind | Description |
|---------|-------------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment with motion |
| `gc` (visual) | Comment selection |

### Autopairs
| Keybind | Description |
|---------|-------------|
| `<M-e>` | Fast wrap (surround next) |

---

## Flash (Quick Navigation)

| Keybind | Description |
|---------|-------------|
| `s` | Flash jump |
| `S` | Flash Treesitter |
| `r` (operator) | Remote Flash |
| `R` (operator/visual) | Treesitter search |
| `<C-s>` (command) | Toggle Flash search |

---

## TODO Comments

| Keybind | Description |
|---------|-------------|
| `]t` | Next TODO |
| `[t` | Previous TODO |
| `<leader>ft` | Find all TODOs |

---

## Marks

| Keybind | Description |
|---------|-------------|
| `m{a-zA-Z}` | Set mark |
| `'{a-zA-Z}` | Jump to mark line |
| `` `{a-zA-Z} `` | Jump to mark position |
| `<leader>fm` | List marks (Telescope) |

---

## Noice (UI)

| Keybind | Description |
|---------|-------------|
| `<leader>snl` | Last message |
| `<leader>snh` | Message history |
| `<leader>sna` | All messages |
| `<leader>snd` | Dismiss all |
| `<S-Enter>` (cmdline) | Redirect cmdline |
| `<C-f>` | Scroll forward (LSP docs) |
| `<C-b>` | Scroll backward (LSP docs) |

---

## Toggles

| Keybind | Description |
|---------|-------------|
| `<leader>ti` | Toggle icons |
| `<leader>th` | Toggle inlay hints |
| `<leader>tb` | Toggle line blame |
| `<leader>td` | Toggle deleted (git) |

---

## Misc

| Keybind | Description |
|---------|-------------|
| `jk` / `jj` | Exit insert mode |
| `<Esc>` | Clear search highlight |
| `<C-s>` | Save file |
| `<leader>qq` | Quit all |
| `n` / `N` | Next/Previous search (centered) |

---

## Useful Commands

```vim
:Mason              " Open LSP/tool installer
:Lazy               " Open plugin manager
:LspInfo            " Show LSP status
:ConformInfo        " Show formatter info
:IconsToggle        " Toggle Nerd Font icons
:FontInfo           " Show font configuration
:Telescope keymaps  " Search all keymaps
:checkhealth        " Diagnose issues
```

---

## Theme (Tokyonight)

**Current Style**: Storm

Switch styles by changing colorscheme command:
```vim
:colorscheme tokyonight-storm  " Default - darker blue-gray
:colorscheme tokyonight-moon   " Balanced contrast
:colorscheme tokyonight-night  " Darkest variant
:colorscheme tokyonight-day    " Light theme
```

**Go Semantic Highlights** (automatic):
- Interfaces: Cyan + italic
- Structs: Blue
- Methods: Blue + bold
- Parameters: Yellow
- Types: Cyan

---

## Go Development Tips

### gopls Code Lenses
- `gc_details` - Show GC optimization details
- `generate` - Run go generate
- `test` - Run tests
- `tidy` - Run go mod tidy
- `upgrade_dependency` - Upgrade dependency
- `vendor` - Run go mod vendor

### Go-Specific Workflow
1. **Find References**: `gr` on a function to see all usages
2. **Implement Interface**: Position on interface, `<leader>ca` for "Implement interface"
3. **Add Tags**: `<leader>ca` on struct field for "Add struct tags"
4. **Generate Tests**: Use `gotests` via `<leader>ca`
5. **Import Organization**: Auto-handled by `goimports` on save

### Debugging Go
```vim
:DapToggleBreakpoint  " Set breakpoint
:DapContinue          " Start/continue debugging
```

---

## Pro Tips

1. **Jump to Error**
   - `]d` / `[d` to cycle through diagnostics
   - `<leader>xx` to see all errors in Trouble panel

2. **Find Function References**
   - `gr` on any function to find all usages
   - Results appear in Telescope, `<C-q>` to send to quickfix

3. **Quick Symbol Navigation**
   - `<leader>ls` for document symbols
   - Type to fuzzy filter

4. **Bulk Edit**
   - Search with `<leader>sg`
   - `<Tab>` to select multiple files
   - `<M-q>` to send selected to quickfix
   - `:cdo s/old/new/g` to replace in all

5. **View Definition Without Jumping**
   - `K` for hover documentation
   - `<C-k>` for function signature

6. **Repeat Last Search**
   - `<leader>f.` resumes last Telescope search

---

## Cheat Sheet Commands

```vim
" In Neovim, press:
<leader>fk    " Search all keymaps
?             " In Telescope normal mode, show keybinds
<leader>fh    " Search help documentation
```

---

*Generated for Neovim config optimized for Go, TypeScript, Vue development*
