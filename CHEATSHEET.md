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

## Understanding Modes (READ THIS FIRST)

Neovim has **separate modes**. The same key does different things depending on
which mode you are in. Look at the bottom-left of your screen to see your
current mode.

```
  NORMAL ──press i/a/o──► INSERT ──press Esc/jk/jj──► NORMAL
    │                                                     ▲
    │──press v/V/Ctrl-v──► VISUAL ──press Esc────────────┘
    │
    │──press :──► COMMAND LINE ──press Enter/Esc──► NORMAL
```

### How to Know Which Mode You Are In
| You see | Mode | What it means |
|---------|------|---------------|
| Nothing / `NORMAL` | Normal | You are navigating. Keys are **commands**, not text |
| `-- INSERT --` | Insert | You are typing text. Keys become **characters** |
| `-- VISUAL --` | Visual | You are selecting text character by character |
| `-- VISUAL LINE --` | Visual Line | You are selecting whole lines |
| `-- VISUAL BLOCK --` | Visual Block | You are selecting a rectangle/column |
| `:` at the bottom | Command | You are typing a vim command |

### How to Get Back to Normal Mode (from ANY mode)
| Keybind | Works from |
|---------|------------|
| `<Esc>` | Any mode → Normal |
| `jk` | Insert → Normal (your config) |
| `jj` | Insert → Normal (your config) |
| `<C-c>` | Any mode → Normal (alternative) |

> **Rule of thumb**: When confused, press `<Esc>` to go back to Normal mode.

---

## NORMAL MODE (default mode - for navigating and commands)

> You are in Normal mode when you first open Neovim.
> Keys are **commands**, not characters. Pressing `d` does not type "d" — it **deletes**.

### Movement (moving your cursor)
| Keybind | What happens | Example |
|---------|-------------|---------|
| `h` `j` `k` `l` | Left, Down, Up, Right | `5j` = move 5 lines down |
| `w` | Jump to start of next word | `3w` = skip 3 words forward |
| `b` | Jump to start of previous word | `2b` = go back 2 words |
| `e` | Jump to end of current/next word | |
| `0` | Jump to beginning of line | |
| `$` | Jump to end of line | |
| `^` | Jump to first non-space character | |
| `gg` | Jump to top of file | |
| `G` | Jump to bottom of file | |
| `{` | Jump to previous blank line | |
| `}` | Jump to next blank line | |
| `%` | Jump to matching bracket `(){}[]` | |
| `<C-d>` | Scroll half page down (centered) | |
| `<C-u>` | Scroll half page up (centered) | |
| `f{char}` | Jump to next `{char}` on this line | `fa` = jump to next "a" |
| `F{char}` | Jump to previous `{char}` on this line | |
| `t{char}` | Jump to just before next `{char}` | |
| `;` | Repeat last `f`/`F`/`t`/`T` forward | |
| `,` | Repeat last `f`/`F`/`t`/`T` backward | |
| `s` | Flash jump (type 2 chars to jump anywhere) | `s` `th` = jump to "th" |

### Entering Insert Mode (from Normal)
| Keybind | Where cursor goes | Use when... |
|---------|-------------------|-------------|
| `i` | Before cursor | Insert text where you are |
| `a` | After cursor | Append text after cursor |
| `I` | Beginning of line | Add text at line start |
| `A` | End of line | Add text at line end |
| `o` | New line below | Start a new line below |
| `O` | New line above | Start a new line above |
| `s` | Delete char + insert | Replace one character |
| `S` | Delete line + insert | Replace entire line |
| `C` | Delete to end + insert | Replace rest of line |
| `ciw` | Delete word + insert | Change a word |
| `ci"` | Delete inside `""` + insert | Change text inside quotes |
| `ci{` | Delete inside `{}` + insert | Change text inside braces |
| `cc` | Delete line + insert | Same as `S` |

### Common Normal Mode Actions
| Keybind | What happens |
|---------|-------------|
| `x` | Delete character under cursor |
| `dd` | Delete entire line |
| `yy` | Yank (copy) entire line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `<C-r>` | Redo |
| `.` | **Repeat last change** (very powerful!) |
| `J` | Join line below to current line |
| `~` | Toggle case of character |
| `r{char}` | Replace single character with `{char}` |
| `R` | Enter Replace mode (overtype) |
| `>>` | Indent line right |
| `<<` | Indent line left |
| `==` | Auto-indent line |
| `<Esc>` | Clear search highlight (your config) |
| `<C-s>` | Save file (your config) |
| `K` | Show hover documentation (LSP) |

---

## Operator + Text Object Combinations (THE CORE OF VIM)

> This is the **most important section** to master. Once you understand this
> system, you can combine any operator with any text object or motion.
> You don't memorize hundreds of commands — you learn a **formula**.

### The Formula

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│   {OPERATOR}  +  {i or a}  +  {TEXT OBJECT}                 │
│                                                              │
│   What to do     inner/around   What to target               │
│                                                              │
│   d = delete     i = inside     w  = word                    │
│   c = change     a = around     W  = WORD                    │
│   y = yank                      s  = sentence                │
│   > = indent                    p  = paragraph               │
│   < = unindent                  "  = double quotes           │
│   gu = lowercase                '  = single quotes           │
│   gU = uppercase                `  = backticks               │
│   v = select                    (  = parentheses             │
│   = = auto-indent               {  = curly braces            │
│                                 [  = square brackets         │
│                                 t  = HTML/XML tag            │
│   OR:                           f  = function (Treesitter)   │
│                                 c  = class (Treesitter)      │
│   {OPERATOR} + {MOTION}         a  = parameter (Treesitter)  │
│                                                              │
│   d + w  = delete to next word                               │
│   d + $  = delete to end of line                             │
│   y + gg = yank to top of file                               │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### `i` (inner) vs `a` (around) — The Key Difference

```
Code:  function greet("hello world") {

         di"   →  deletes:  hello world     →  result: ("")
         da"   →  deletes:  "hello world"   →  result: ()

         di(   →  deletes:  "hello world"   →  result: ()
         da(   →  deletes:  ("hello world") →  result:

         di{   →  deletes:  contents of {}  →  result: {}
         da{   →  deletes:  { and contents} →  result: (nothing)
```

> **When to use `i`**: You want to replace the content but keep the container.
> **When to use `a`**: You want to remove everything including the container.

### All Operators Explained

| Operator | Name | What it does | Stays in |
|----------|------|-------------|----------|
| `d` | Delete | Removes text (saved to register, can paste) | Normal |
| `c` | Change | Removes text and starts typing | Insert |
| `y` | Yank | Copies text (doesn't remove) | Normal |
| `v` | Select | Highlights text | Visual |
| `>` | Indent | Shifts text right | Normal |
| `<` | Unindent | Shifts text left | Normal |
| `=` | Auto-indent | Fixes indentation | Normal |
| `gu` | Lowercase | Makes text lowercase | Normal |
| `gU` | Uppercase | Makes text UPPERCASE | Normal |
| `g~` | Toggle case | Swaps upper/lower | Normal |
| `gq` | Format | Reflow/wrap text | Normal |

> **Shortcut**: Double the operator to act on the whole line:
> `dd` = delete line, `yy` = yank line, `cc` = change line, `>>` = indent line, `==` = auto-indent line, `gUU` = uppercase line

### All Text Objects

#### Built-in Text Objects
| Object | What it targets | Example with `d` |
|--------|----------------|-------------------|
| `w` | word | `diw` = delete word |
| `W` | WORD (no punctuation split) | `diW` = delete WORD |
| `s` | sentence | `dis` = delete sentence |
| `p` | paragraph | `dip` = delete paragraph |
| `"` | double-quoted string | `di"` = delete inside `"..."` |
| `'` | single-quoted string | `di'` = delete inside `'...'` |
| `` ` `` | backtick string | `` di` `` = delete inside `` `...` `` |
| `(` or `)` or `b` | parentheses | `di(` = delete inside `(...)` |
| `{` or `}` or `B` | curly braces | `di{` = delete inside `{...}` |
| `[` or `]` | square brackets | `di[` = delete inside `[...]` |
| `<` or `>` | angle brackets | `di<` = delete inside `<...>` |
| `t` | HTML/XML tag | `dit` = delete inside `<p>...</p>` |

#### Treesitter Text Objects (your config)
| Object | What it targets | Example with `d` |
|--------|----------------|-------------------|
| `f` | function | `dif` = delete function body, `daf` = delete whole function |
| `c` | class/struct | `dic` = delete class body, `dac` = delete whole class |
| `a` | parameter/argument | `dia` = delete parameter, `daa` = delete param + comma |

### Operator + Motion (without text objects)

> Instead of `i`/`a` + text object, you can use a **motion** directly.

| Combo | What it does |
|-------|-------------|
| `dw` | Delete from cursor to start of next word |
| `d$` or `D` | Delete from cursor to end of line |
| `d0` | Delete from cursor to start of line |
| `d^` | Delete from cursor to first non-space |
| `dG` | Delete from cursor to end of file |
| `dgg` | Delete from cursor to start of file |
| `d}` | Delete from cursor to next blank line |
| `d%` | Delete from cursor to matching bracket |
| `df{char}` | Delete from cursor to next `{char}` (inclusive) |
| `dt{char}` | Delete from cursor to just before `{char}` |
| `d/pattern<CR>` | Delete from cursor to next search match |
| `d]f` | Delete from cursor to next function start |

> All of the above work with `c`, `y`, `v`, `>`, `gu`, `gU` too!
> Just swap the `d` for any operator.

### Complete Combination Matrix

> Every cell is a valid command. **This is the power of Vim.**

| | `iw` word | `i"` quotes | `i{` braces | `i(` parens | `it` tag | `if` func | `ic` class | `ia` param |
|---|---|---|---|---|---|---|---|---|
| **`d`** delete | `diw` | `di"` | `di{` | `di(` | `dit` | `dif` | `dic` | `dia` |
| **`c`** change | `ciw` | `ci"` | `ci{` | `ci(` | `cit` | `cif` | `cic` | `cia` |
| **`y`** yank | `yiw` | `yi"` | `yi{` | `yi(` | `yit` | `yif` | `yic` | `yia` |
| **`v`** select | `viw` | `vi"` | `vi{` | `vi(` | `vit` | `vif` | `vic` | `via` |
| **`>`** indent | `>iw` | `>i"` | `>i{` | `>i(` | `>it` | `>if` | `>ic` | — |
| **`<`** unindent | `<iw` | `<i"` | `<i{` | `<i(` | `<it` | `<if` | `<ic` | — |
| **`=`** format | `=iw` | `=i"` | `=i{` | `=i(` | `=it` | `=if` | `=ic` | — |
| **`gu`** lower | `guiw` | `gui"` | `gui{` | `gui(` | — | — | — | — |
| **`gU`** UPPER | `gUiw` | `gUi"` | `gUi{` | `gUi(` | — | — | — | — |

> Replace `i` with `a` in any cell for the "around" variant (includes delimiters).

### With Surround Plugin (nvim-surround)

Your surround plugin adds its own operators:

| Combo | What it does | Example |
|-------|-------------|---------|
| `ys{motion}{char}` | **Add** surround | `ysiw"` → surround word with `"` |
| `yss{char}` | Surround entire line | `yss(` → wrap line in `()` |
| `ds{char}` | **Delete** surround | `ds"` → remove surrounding `"` |
| `cs{old}{new}` | **Change** surround | `cs"'` → change `"` to `'` |
| `cs{old}t` | Change to tag | `cs"t` → asks for tag, e.g., `<p>` |

### Real-World Examples by Language

#### Go
```
func Ha‖ndler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello")
}

  daf  → delete entire function (Handler + body + closing brace)
  cif  → delete function body, cursor inside {} ready to type
  yaf  → copy entire function (paste elsewhere with p)
  vaf  → select entire function (then move/comment/indent)

  ci"  → on "Hello" line: delete Hello, type replacement
  da(  → on Fprintf line: delete (w, "Hello") including parens

  dia  → on `w http.ResponseWriter`: delete just that parameter
  daa  → delete parameter + trailing comma
```

#### TypeScript / JavaScript
```
const us‖ers = data.filter((user) => {
  return user.age > 18;
});

  ci{  → delete inside { }, type new body
  di(  → on filter line: delete (user) => { ... } inside parens
  caw  → change the word "users" to something else

const gre‖et = "Hello, World!";

  ci"  → delete Hello, World! and type new string
  da"  → delete "Hello, World!" including the quotes
  yiw  → copy just the word "greet"
```

#### HTML / Vue
```
<di‖v class="container">
  <p>Hello World</p>
</div>

  dit  → delete everything between <div> and </div>
  dat  → delete the entire <div>...</div> including tags
  cit  → delete inner content, type new content

  <p>He‖llo World</p>
  cit  → delete "Hello World", type replacement
  dit  → delete "Hello World", stay in normal mode

  class="con‖tainer"
  ci"  → delete "container", type new class name
```

#### JSON
```
{
  "na‖me": "John",
  "age": 30,
  "address": {
    "city": "NYC"
  }
}

  ci"  → on "name": change the key name
  2f"ci" → jump to "John", change the value
  di{  → delete everything inside outer { }
  vi{  → select everything inside outer { }
```

### Combining with Count

> Add a number before operator or motion to repeat:

| Combo | What it does |
|-------|-------------|
| `d2w` | Delete 2 words |
| `c3w` | Change 3 words |
| `y5j` | Yank current line + 5 lines below |
| `d2f)` | Delete to 2nd `)` |
| `>2}` | Indent 2 paragraphs |
| `2dd` | Delete 2 lines |
| `3yy` | Yank 3 lines |

### Combining with Dot (`.`) — Repeat Pattern

> The `.` command repeats your last **change**. This is the biggest productivity trick.

```
Example: Change all "foo" to "bar" manually

  /foo<CR>     → search for "foo"
  ciw          → delete word, enter insert
  bar<Esc>     → type "bar", back to normal
  n            → jump to next "foo"
  .            → repeat the ciw + bar instantly!
  n.           → next match and repeat... keep going
```

```
Example: Add quotes around multiple words

  ysiw"        → surround first word with "
  w            → move to next word
  .            → repeat surround! (ysiw")
  w.           → again... keep going
```

```
Example: Delete every function body

  dif          → delete inside first function
  ]f           → jump to next function
  .            → repeat dif
  ]f.          → keep going...
```

### Practice Exercises

Try these on any code file to build muscle memory:

```
1. WORDS:    Place cursor on any word, try:  diw  ciw  yiw  viw
2. QUOTES:   Place cursor inside "string", try:  di"  ci"  yi"  vi"
3. BRACES:   Place cursor inside { block }, try:  di{  ci{  yi{  vi{
4. PARENS:   Place cursor inside (args), try:    di(  ci(  yi(  vi(
5. FUNCTION: Place cursor inside a function, try: dif  cif  yif  vif
6. TAGS:     Place cursor inside <tag>text</tag>, try: dit  cit
7. AROUND:   Redo exercises 2-6 but use 'a' instead of 'i'
             Compare: di" vs da"  |  di{ vs da{  |  dif vs daf
8. DOT:      Do ciw on a word, type new text, Esc. Move to another word, press .
9. COUNT:    Try d2w  y3j  c2f)  >2}
```

### Searching (Normal mode)
| Keybind | What happens |
|---------|-------------|
| `/pattern` | Search forward for "pattern" |
| `?pattern` | Search backward for "pattern" |
| `n` | Jump to next match (centered) |
| `N` | Jump to previous match (centered) |
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |
| `<Esc>` | Clear search highlight |

### Marks & Jumps (Normal mode)
| Keybind | What happens |
|---------|-------------|
| `m{a-z}` | Set mark (local to file) |
| `'{a-z}` | Jump to mark line |
| `` `{a-z} `` | Jump to mark exact position |
| `<C-o>` | Jump to previous location (jump list) |
| `<C-i>` | Jump to next location (jump list) |
| `gi` | Jump to last insert location + insert mode |
| `g;` | Jump to previous change location |
| `g,` | Jump to next change location |
| `gv` | Reselect last visual selection |
| `gd` | Go to definition (LSP) |
| `gr` | Go to references (LSP) |

### Macros (Normal mode - record & replay)
```
qa           → Start recording into register "a"
  ...do stuff...
q            → Stop recording
@a           → Play the macro
@@           → Replay last macro
5@a          → Play macro 5 times
```

### Window / Buffer / Tab (Normal mode with leader)
| Keybind | What happens |
|---------|-------------|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Navigate between windows |
| `<S-h>` / `<S-l>` | Previous / Next buffer |
| `<leader>bd` | Close current buffer |
| `<leader>wv` | Split window vertical |
| `<leader>ws` | Split window horizontal |
| `<leader>wc` | Close window |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>sg` | Search text in project |
| `<leader>qq` | Quit all |

---

## INSERT MODE (for typing text)

> You are in Insert mode when you see `-- INSERT --` at the bottom.
> Keys type characters. Most "commands" use Ctrl combinations.

### How You Got Here
You pressed `i`, `a`, `o`, `I`, `A`, `O`, `s`, `S`, `C`, `c{motion}`, or
similar from Normal mode.

### Editing While in Insert Mode
| Keybind | What happens |
|---------|-------------|
| (just type) | Characters appear as text |
| `<Esc>` | Exit to Normal mode |
| `jk` | Exit to Normal mode (your config) |
| `jj` | Exit to Normal mode (your config) |
| `<C-s>` | Save file (your config, stays in Insert) |
| `<Backspace>` | Delete character before cursor |
| `<Delete>` | Delete character after cursor |
| `<C-w>` | Delete word before cursor |
| `<C-u>` | Delete everything before cursor on this line |
| `<C-h>` | Same as Backspace |
| `<C-t>` | Indent current line |
| `<C-d>` | Unindent current line |
| `<C-r>{reg}` | Paste from register (e.g., `<C-r>0` = paste yanked) |
| `<C-r>"` | Paste from default register |
| `<C-r>+` | Paste from system clipboard |
| `<C-a>` | Re-insert last inserted text |
| `<C-k>` | Signature help (LSP, your config) |
| `<A-j>` | Move line down (your config) |
| `<A-k>` | Move line up (your config) |

### Completion While in Insert Mode (nvim-cmp)
| Keybind | What happens |
|---------|-------------|
| (start typing) | Completion popup appears automatically |
| `<C-Space>` | Manually trigger completion |
| `<Tab>` | Select next completion item / expand snippet |
| `<S-Tab>` | Select previous completion item |
| `<C-n>` | Next completion item |
| `<C-p>` | Previous completion item |
| `<CR>` (Enter) | Confirm selected completion |
| `<C-e>` | Close/abort completion popup |
| `<C-b>` | Scroll completion docs up |
| `<C-f>` | Scroll completion docs down |
| `<C-l>` | Jump to next snippet placeholder |
| `<C-h>` | Jump to previous snippet placeholder |

### Undo Breakpoints (your config)
Your config adds undo breakpoints at `,` `.` `;` in insert mode.
This means pressing `u` in Normal mode undoes back to the last comma/period/semicolon,
not the entire insert session.

### Auto Features in Insert Mode
- **Autopairs**: Typing `(` auto-inserts `)`, same for `{`, `[`, `"`, `'`
- **Auto-tag**: In HTML/Vue, typing `<div>` auto-inserts `</div>`
- **LSP completion**: Suggestions appear as you type
- **Signature help**: `<C-k>` shows function parameters

> **Tip**: Don't stay in Insert mode to navigate! Press `<Esc>` (or `jk`),
> move with Normal mode commands, then re-enter Insert mode. This is faster.

---

## VISUAL MODE (for selecting text)

> You are in Visual mode when you see `-- VISUAL --`, `-- VISUAL LINE --`,
> or `-- VISUAL BLOCK --` at the bottom. Text will be highlighted.

### How to Enter Visual Mode (from Normal)
| Keybind | What it does | Use when... |
|---------|-------------|-------------|
| `v` | Character visual | Select specific characters/words |
| `V` | Line visual | Select whole lines |
| `<C-v>` | Block visual | Select a rectangle/column |

### Moving While Selecting
Once in Visual mode, all Normal mode **movement keys** extend the selection:

| Keybind | What happens |
|---------|-------------|
| `h` `j` `k` `l` | Extend selection left/down/up/right |
| `w` / `b` | Extend selection by word forward/backward |
| `e` | Extend to end of word |
| `$` | Extend to end of line |
| `0` / `^` | Extend to start of line |
| `}` / `{` | Extend to next/previous paragraph |
| `gg` / `G` | Extend to top/bottom of file |
| `%` | Extend to matching bracket |
| `f{char}` | Extend to next `{char}` on line |
| `iw` | Expand to select inner word |
| `aw` | Expand to select a word |
| `i{` / `i}` | Expand to select inside `{}` |
| `a{` / `a}` | Expand to select around `{}` |
| `i(` / `i)` | Expand to select inside `()` |
| `i"` / `i'` | Expand to select inside quotes |
| `it` / `at` | Expand to select inside/around HTML tag |
| `if` / `af` | Expand to select inside/around function |
| `ic` / `ac` | Expand to select inside/around class |
| `ia` / `aa` | Expand to select inside/around parameter |
| `o` | Jump cursor to other end of selection |
| `<C-Space>` | Smart expand selection (Treesitter) |
| `<BS>` | Smart shrink selection (Treesitter) |

### Actions on Selection
Once you have text selected, press one of these:

| Keybind | What happens |
|---------|-------------|
| `d` or `x` | Delete selection |
| `c` | Delete selection + enter Insert mode |
| `y` | Yank (copy) selection |
| `p` | Replace selection with paste (your config: no yank) |
| `>` | Indent right (stays in Visual, your config) |
| `<` | Indent left (stays in Visual, your config) |
| `=` | Auto-indent selection |
| `u` | Lowercase selection |
| `U` | Uppercase selection |
| `~` | Toggle case of selection |
| `J` | Join selected lines |
| `gc` | Toggle comment on selection |
| `gq` | Reformat/rewrap selection |
| `<A-j>` | Move selection down (your config) |
| `<A-k>` | Move selection up (your config) |
| `"+y` | Yank selection to system clipboard |
| `:s/old/new/g` | Replace within selection (auto-adds range) |
| `<Esc>` | Cancel selection, back to Normal |

### Common Selection Recipes

**Select a word and change it**:
```
viw          → select the word under cursor
c            → delete it and enter insert mode
(type new)   → type replacement
<Esc>        → done
```

**Select inside braces and delete**:
```
vi{          → select everything inside { }
d            → delete it
```

**Select a function and copy it**:
```
vaf          → select entire function (Treesitter)
y            → yank (copy) it
```

**Select multiple lines and comment**:
```
V            → enter line visual mode
jjj          → select 3 more lines down
gc           → toggle comment on all selected lines
```

**Select and indent a block**:
```
vi{          → select inside braces
>            → indent (stays in visual, press > again for more)
<Esc>        → done
```

**Select all and copy to clipboard**:
```
ggVG         → go to top, line visual, go to bottom = select all
"+y          → yank to system clipboard
```

**Smart expand with Treesitter**:
```
<C-Space>    → start selection (word)
<C-Space>    → expand to larger syntax node (expression, statement...)
<C-Space>    → expand again (block, function...)
<BS>         → shrink back one level
```

### Visual Block Mode (`<C-v>`) - Column Editing

This is the most powerful visual mode. It selects a **rectangle**.

**Add text to multiple lines at once**:
```
<C-v>        → enter block visual mode
jjj          → select 4 lines down
I            → insert at the start of block
//           → type "//" (or any text)
<Esc>        → applied to ALL selected lines!
```

**Append text to multiple lines**:
```
<C-v>        → enter block visual mode
jjj$         → select 4 lines to end
A            → append at end of block
;            → type ";" (or any text)
<Esc>        → applied to ALL selected lines!
```

**Delete a column**:
```
<C-v>        → enter block visual mode
jjj          → select 4 lines
ll           → extend selection 2 columns right
d            → delete the rectangle
```

**Replace a column**:
```
<C-v>        → enter block visual mode
jjjee        → select rectangle
c            → change block
(type new)   → type replacement
<Esc>        → applied to ALL lines!
```

---

## COMMAND MODE (for ex commands)

> You enter Command mode by pressing `:` from Normal mode.
> The cursor jumps to the bottom of the screen.

### How to Enter / Exit
| Keybind | What happens |
|---------|-------------|
| `:` | Enter command mode (from Normal) |
| `<CR>` (Enter) | Execute command and return to Normal |
| `<Esc>` | Cancel and return to Normal |

### File Commands
| Command | What it does |
|---------|-------------|
| `:w` | Save file |
| `:q` | Quit (fails if unsaved) |
| `:wq` or `:x` | Save and quit |
| `:q!` | Quit without saving |
| `:qa` | Quit all windows |
| `:e {file}` | Open/edit a file |
| `:saveas {file}` | Save as new filename |

### Search & Replace Commands
| Command | What it does |
|---------|-------------|
| `:%s/old/new/g` | Replace all "old" with "new" in file |
| `:%s/old/new/gc` | Replace all with confirmation (y/n each) |
| `:'<,'>s/old/new/g` | Replace in visual selection only |
| `:s/old/new/g` | Replace on current line only |
| `:%s/old/new/gi` | Replace all, case insensitive |

### Line Commands
| Command | What it does |
|---------|-------------|
| `:10` | Jump to line 10 |
| `:d` | Delete current line |
| `:5,10d` | Delete lines 5 through 10 |
| `:t.` | Duplicate current line |
| `:5t10` | Copy line 5 to after line 10 |
| `:5m10` | Move line 5 to after line 10 |
| `:sort` | Sort selected lines |
| `:sort u` | Sort and remove duplicates |

### Global Commands (powerful!)
| Command | What it does |
|---------|-------------|
| `:g/pattern/d` | Delete all lines containing "pattern" |
| `:v/pattern/d` | Delete all lines NOT containing "pattern" |
| `:g/pattern/m$` | Move all matching lines to end of file |
| `:g/TODO/p` | Print all lines containing "TODO" |

### Useful Commands for Your Config
| Command | What it does |
|---------|-------------|
| `:Mason` | Open LSP/tool installer |
| `:Lazy` | Open plugin manager |
| `:LspInfo` | Show active language servers |
| `:ConformInfo` | Show formatter info |
| `:checkhealth` | Diagnose Neovim issues |
| `:Telescope keymaps` | Search all keybindings |
| `:set rnu!` | Toggle relative line numbers |
| `:earlier 5m` | Undo back 5 minutes |
| `:later 5m` | Redo forward 5 minutes |
| `:%y+` | Copy entire file to system clipboard |
| `:%!jq .` | Format JSON with jq |

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

## Selection Techniques

### Select Word
| Keybind | Description |
|---------|-------------|
| `viw` | Select inner word (no spaces) |
| `vaw` | Select a word (with trailing space) |
| `viW` | Select inner WORD (non-whitespace chars) |
| `vaW` | Select a WORD (with trailing space) |
| `viwp` | Select word and replace with paste |
| `ciw` | Change inner word (delete + insert mode) |
| `diw` | Delete inner word |
| `yiw` | Yank (copy) inner word |
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |

### Select Block / Scope
| Keybind | Description |
|---------|-------------|
| `vi{` / `vi}` | Select inside `{ }` braces |
| `va{` / `va}` | Select around `{ }` braces |
| `vi(` / `vi)` | Select inside `( )` parentheses |
| `va(` / `va)` | Select around `( )` parentheses |
| `vi[` / `vi]` | Select inside `[ ]` brackets |
| `vi"` | Select inside double quotes |
| `vi'` | Select inside single quotes |
| `` vi` `` | Select inside backticks |
| `vit` | Select inside HTML/XML tag |
| `vat` | Select around HTML/XML tag |
| `vib` | Select inside block `()` |
| `viB` | Select inside Block `{}` |

### Treesitter Smart Selection (configured in your setup)
| Keybind | Description |
|---------|-------------|
| `<C-Space>` | Start/Expand selection (incremental) |
| `<BS>` | Shrink selection (decremental) |
| `vif` | Select inside function body |
| `vaf` | Select entire function |
| `vic` | Select inside class body |
| `vac` | Select entire class |
| `via` / `vaa` | Select inside/around parameter |

### Select All
| Keybind | Description |
|---------|-------------|
| `ggVG` | Select entire file content |
| `ggVGy` | Select all and yank (copy) |
| `ggVGd` | Select all and delete |
| `gg"+yG` | Yank entire file to system clipboard |
| `:%y+` | Yank entire file to clipboard (command) |

---

## Code Folding (Treesitter-based)

> Your config uses treesitter foldexpr with all folds open by default.

### Basic Folding
| Keybind | Description |
|---------|-------------|
| `za` | Toggle fold under cursor |
| `zo` | Open fold under cursor |
| `zc` | Close fold under cursor |
| `zR` | Open ALL folds in file |
| `zM` | Close ALL folds in file |
| `zA` | Toggle fold recursively |
| `zO` | Open fold recursively |
| `zC` | Close fold recursively |

### Fold Navigation
| Keybind | Description |
|---------|-------------|
| `zj` | Move to next fold |
| `zk` | Move to previous fold |
| `[z` | Go to start of current fold |
| `]z` | Go to end of current fold |

### Fold Levels
| Keybind | Description |
|---------|-------------|
| `zm` | Fold more (reduce foldlevel by 1) |
| `zr` | Fold less (increase foldlevel by 1) |
| `z1` ... `z9` | Set foldlevel to 1-9 (`:set foldlevel=N`) |

### Fold Workflow
```
zM       → Close everything (overview mode)
zr       → Reveal one more level
zR       → Open everything (back to normal)
za       → Toggle specific fold under cursor
```

---

## Productivity Tricks

### Quick Replace / Rename
| Keybind | Description |
|---------|-------------|
| `<leader>cr` | LSP rename symbol (project-wide) |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:'<,'>s/old/new/g` | Replace in visual selection |
| `*Ncgn` | Select word, skip one, change next match |
| `cgn` | Change next search match (repeat with `.`) |

### The Dot Command (`.`) - Repeat Last Change
```
ciw"hello"<Esc>   → Change word to "hello"
w.                 → Move to next word, repeat the change
```

### Macros (Record & Replay)
| Keybind | Description |
|---------|-------------|
| `qa` | Start recording macro into register `a` |
| `q` | Stop recording |
| `@a` | Play macro from register `a` |
| `@@` | Replay last macro |
| `10@a` | Play macro 10 times |
| `:'<,'>normal @a` | Play macro on each selected line |

### Multi-line Editing (Visual Block)
```
<C-v>              → Enter visual block mode
jjj                → Select lines down
I                  → Insert at beginning of block
<text><Esc>        → Applied to all selected lines
```

```
<C-v>              → Enter visual block mode
jjj$               → Select to end of lines
A                  → Append at end of block
<text><Esc>        → Applied to all selected lines
```

### Registers & Clipboard
| Keybind | Description |
|---------|-------------|
| `"+y` | Yank to system clipboard |
| `"+p` | Paste from system clipboard |
| `"0p` | Paste last yanked text (not deleted) |
| `"ay` | Yank into register `a` |
| `"ap` | Paste from register `a` |
| `:reg` | View all registers |
| `<leader>fR` | Browse registers (Telescope) |

### Undo & Redo
| Keybind | Description |
|---------|-------------|
| `u` | Undo |
| `<C-r>` | Redo |
| `:earlier 5m` | Go back 5 minutes |
| `:later 5m` | Go forward 5 minutes |

### Treesitter Navigation (configured in your setup)
| Keybind | Description |
|---------|-------------|
| `]f` | Jump to next function |
| `[f` | Jump to previous function |
| `]c` | Jump to next class |
| `[c` | Jump to previous class |
| `<leader>sn` | Swap parameter with next |
| `<leader>sp` | Swap parameter with previous |
| `<leader>tc` | Toggle treesitter context (sticky header) |

### Speed Tricks
| Keybind | Description |
|---------|-------------|
| `<C-o>` | Jump back to previous location |
| `<C-i>` | Jump forward to next location |
| `gi` | Go to last insert position + insert mode |
| `gv` | Reselect last visual selection |
| `g;` / `g,` | Jump through change list |
| `zz` / `zt` / `zb` | Center / Top / Bottom cursor on screen |
| `:set rnu!` | Toggle relative line numbers |
| `J` | Join line below to current line |
| `gJ` | Join without adding space |
| `~` | Toggle case of character |
| `gU{motion}` | Uppercase (e.g., `gUiw` = uppercase word) |
| `gu{motion}` | Lowercase (e.g., `guiw` = lowercase word) |

### Command Mode Power
```vim
:g/pattern/d        " Delete all lines matching pattern
:v/pattern/d        " Delete all lines NOT matching pattern
:g/pattern/m$       " Move all matching lines to end
:sort                " Sort selected lines
:sort u              " Sort and remove duplicates
:%!jq .              " Format JSON with external tool
```

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
