-- Icons Configuration
-- Centralized icon definitions with Nerd Font fallback support
-- Optimized for Go development workflow

local M = {}

-- Global toggle for icons (set to false for SSH/tmux without Nerd Fonts)
-- Can be overridden via environment variable: NVIM_ICONS=0
M.enabled = vim.env.NVIM_ICONS ~= "0"

-- Detect if we're in a limited environment (SSH without proper font support)
local function detect_limited_env()
  local ssh = vim.env.SSH_CLIENT or vim.env.SSH_TTY
  local term = vim.env.TERM or ""
  -- Assume limited if SSH and not using a known good terminal
  if ssh and not (term:match("xterm%-256color") or term:match("tmux%-256color")) then
    return true
  end
  return false
end

-- Auto-disable icons in limited environments unless explicitly enabled
if detect_limited_env() and vim.env.NVIM_ICONS ~= "1" then
  M.enabled = false
end

-- Nerd Font icons (primary)
local nerd = {
  -- Diagnostics
  diagnostics = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
  },

  -- Git
  git = {
    added = " ",
    modified = " ",
    removed = " ",
    renamed = "󰁕 ",
    untracked = " ",
    ignored = " ",
    unstaged = "󰄱 ",
    staged = " ",
    conflict = " ",
    branch = " ",
  },

  -- File types
  files = {
    default = " ",
    symlink = " ",
    folder_closed = " ",
    folder_open = " ",
    folder_empty = " ",
  },

  -- Go-specific icons
  go = {
    go = " ",           -- Go gopher
    go_mod = " ",       -- Module file
    go_sum = " ",       -- Sum file
    go_test = " ",      -- Test file
    go_tmpl = " ",      -- Template
    vendor = "󰏗 ",       -- Vendor directory
    generated = "󰑣 ",    -- Generated file
  },

  -- UI elements
  ui = {
    arrow_right = " ",
    arrow_left = " ",
    arrow_up = " ",
    arrow_down = " ",
    breadcrumb = "»",
    separator = "➜",
    group = "+ ",
    ellipsis = "…",
    clock = " ",
    check = " ",
    close = " ",
    code = " ",
    cog = " ",
    debug = " ",
    event = " ",
    file = " ",
    find = " ",
    lazy = "󰒲 ",
    list = " ",
    lock = " ",
    new_file = " ",
    package = " ",
    plugin = " ",
    quit = " ",
    recent = " ",
    search = " ",
    source = " ",
    start = " ",
    task = " ",
    terminal = " ",
  },

  -- LSP kinds (for completion)
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },

  -- DAP (debugging)
  dap = {
    breakpoint = " ",
    breakpoint_condition = " ",
    breakpoint_rejected = " ",
    log_point = "󰛿 ",
    stopped = " ",
  },

  -- Borders
  border = {
    rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
  },

  -- Tree/indent
  tree = {
    expander_collapsed = " ",
    expander_expanded = " ",
    indent_marker = "│",
    last_indent_marker = "└",
  },

  -- Progress/spinner
  spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
}

-- ASCII fallback icons (for environments without Nerd Fonts)
local ascii = {
  diagnostics = {
    error = "E ",
    warn = "W ",
    hint = "H ",
    info = "I ",
  },

  git = {
    added = "+ ",
    modified = "~ ",
    removed = "- ",
    renamed = "R ",
    untracked = "? ",
    ignored = "! ",
    unstaged = "U ",
    staged = "S ",
    conflict = "C ",
    branch = "@ ",
  },

  files = {
    default = "* ",
    symlink = "@ ",
    folder_closed = "+ ",
    folder_open = "- ",
    folder_empty = "= ",
  },

  go = {
    go = "Go",
    go_mod = "Mod",
    go_sum = "Sum",
    go_test = "T ",
    go_tmpl = "Tm",
    vendor = "V ",
    generated = "G ",
  },

  ui = {
    arrow_right = "> ",
    arrow_left = "< ",
    arrow_up = "^ ",
    arrow_down = "v ",
    breadcrumb = ">",
    separator = "->",
    group = "+ ",
    ellipsis = "...",
    clock = "@ ",
    check = "* ",
    close = "x ",
    code = "# ",
    cog = "% ",
    debug = "D ",
    event = "E ",
    file = "F ",
    find = "/ ",
    lazy = "L ",
    list = "= ",
    lock = "! ",
    new_file = "+ ",
    package = "P ",
    plugin = "* ",
    quit = "Q ",
    recent = "R ",
    search = "? ",
    source = "S ",
    start = "> ",
    task = "T ",
    terminal = "$ ",
  },

  kinds = {
    Array = "[] ",
    Boolean = "b ",
    Class = "C ",
    Codeium = "Ai",
    Color = "# ",
    Control = "^ ",
    Collapsed = "+ ",
    Constant = "c ",
    Constructor = "C ",
    Copilot = "Cp",
    Enum = "E ",
    EnumMember = "e ",
    Event = "E ",
    Field = "f ",
    File = "F ",
    Folder = "D ",
    Function = "fn",
    Interface = "I ",
    Key = "K ",
    Keyword = "k ",
    Method = "m ",
    Module = "M ",
    Namespace = "N ",
    Null = "0 ",
    Number = "# ",
    Object = "O ",
    Operator = "o ",
    Package = "P ",
    Property = "p ",
    Reference = "& ",
    Snippet = "S ",
    String = "s ",
    Struct = "S ",
    Supermaven = "Sm",
    TabNine = "Tn",
    Text = "T ",
    TypeParameter = "t ",
    Unit = "U ",
    Value = "v ",
    Variable = "V ",
  },

  dap = {
    breakpoint = "B ",
    breakpoint_condition = "C ",
    breakpoint_rejected = "R ",
    log_point = "L ",
    stopped = "> ",
  },

  border = {
    rounded = { "+", "-", "+", "|", "+", "-", "+", "|" },
    single = { "+", "-", "+", "|", "+", "-", "+", "|" },
    double = { "+", "=", "+", "|", "+", "=", "+", "|" },
  },

  tree = {
    expander_collapsed = "+ ",
    expander_expanded = "- ",
    indent_marker = "|",
    last_indent_marker = "`",
  },

  spinner = { "|", "/", "-", "\\" },
}

-- Select icon set based on enabled state
local function get_icons()
  return M.enabled and nerd or ascii
end

-- Public API: Get icon by category and name
function M.get(category, name)
  local icons = get_icons()
  if icons[category] and icons[category][name] then
    return icons[category][name]
  end
  return ""
end

-- Public API: Get entire category
function M.category(name)
  local icons = get_icons()
  return icons[name] or {}
end

-- Public API: Get all icons
function M.all()
  return get_icons()
end

-- Toggle icons on/off
function M.toggle()
  M.enabled = not M.enabled
  vim.notify(
    "Icons " .. (M.enabled and "enabled" or "disabled") .. " (restart recommended)",
    vim.log.levels.INFO
  )
end

-- User command to toggle icons
vim.api.nvim_create_user_command("IconsToggle", function()
  M.toggle()
end, { desc = "Toggle Nerd Font icons on/off" })

return M
