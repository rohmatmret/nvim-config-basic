-- Neovim Options
-- Performance-optimized settings for modern development

local opt = vim.opt

-- Encoding (required for Nerd Font icons)
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- Shown in statusline instead
opt.cmdheight = 1
opt.laststatus = 3 -- Global statusline
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Performance
opt.updatetime = 200 -- Faster CursorHold events
opt.timeoutlen = 300 -- Faster key sequence completion
opt.redrawtime = 1500
opt.lazyredraw = false -- Disabled for noice.nvim compatibility

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10
opt.pumblend = 10

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Misc
opt.clipboard = "unnamedplus" -- System clipboard
opt.mouse = "a"
opt.virtualedit = "block"
opt.inccommand = "split" -- Live preview for substitute
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Filetype-specific settings
vim.filetype.add({
  extension = {
    templ = "templ",
  },
  pattern = {
    [".*%.go%.tmpl"] = "gotmpl",
    [".*%.tmpl"] = "gotmpl",
  },
})

-- Disable some builtin plugins for faster startup
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
