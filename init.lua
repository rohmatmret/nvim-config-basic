--[[
  Neovim Configuration for Full-Stack Development
  Optimized for: Go, React (TS/JS), Vue.js
  Plugin Manager: lazy.nvim

  Structure:
  - lua/config/options.lua   → Neovim settings
  - lua/config/keymaps.lua   → Key mappings
  - lua/config/autocmds.lua  → Autocommands
  - lua/config/lazy.lua      → Plugin manager bootstrap
  - lua/plugins/             → Plugin specifications
]]

-- Set leader key early (before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.icons")  -- Load icons early for plugin use

-- Bootstrap and load plugins
require("config.lazy")
