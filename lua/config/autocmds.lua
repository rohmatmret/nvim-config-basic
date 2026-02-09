-- Autocommands
-- Smart automation for better editing experience

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Resize splits on window resize
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Go to last position when opening a buffer
autocmd("BufReadPost", {
  group = augroup("LastPosition", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with <q>
autocmd("FileType", {
  group = augroup("CloseWithQ", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "checkhealth",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Quit from alpha dashboard with q
autocmd("FileType", {
  group = augroup("AlphaQuit", { clear = true }),
  pattern = { "alpha" },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>qa<cr>", { buffer = event.buf, silent = true, nowait = true })
  end,
})

-- Auto create parent directories when saving a file
autocmd("BufWritePre", {
  group = augroup("AutoCreateDir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Wrap and spell check in text files
autocmd("FileType", {
  group = augroup("WrapSpell", { clear = true }),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
autocmd("FileType", {
  group = augroup("JsonConceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Filetype-specific indentation
autocmd("FileType", {
  group = augroup("Indentation", { clear = true }),
  pattern = { "go", "make" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

autocmd("FileType", {
  group = augroup("TwoSpaceIndent", { clear = true }),
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "json", "yaml", "html", "css", "scss" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Trim trailing whitespace on save (except for certain filetypes)
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  callback = function()
    local exclude = { "markdown", "diff" }
    if vim.tbl_contains(exclude, vim.bo.filetype) then
      return
    end
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Check if file changed outside of nvim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("CheckTime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
