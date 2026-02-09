-- Font Configuration Guide for Neovim
-- Optimized for Go development with Nerd Font icons
--
-- This file serves as documentation and optional runtime font checks.
-- It does NOT set fonts (that's done in your terminal emulator).

local M = {}

--[[
================================================================================
RECOMMENDED FONTS FOR GO DEVELOPMENT
================================================================================

1. JetBrainsMono Nerd Font (PRIMARY RECOMMENDATION)
   - Why: Designed specifically for code, excellent Go keyword readability
   - Ligatures: Supported (optional, can be disabled)
   - Go benefits:
     * Clear distinction between 0/O/o and 1/l/I
     * Excellent := operator visibility
     * Wide character set for Go's Unicode support
   - Installation:
     brew install --cask font-jetbrains-mono-nerd-font

2. FiraCode Nerd Font (ALTERNATIVE)
   - Why: Popular, well-tested ligatures, good readability
   - Ligatures: Designed around ligatures (highly recommended to enable)
   - Go benefits:
     * Beautiful -> and := ligatures
     * Compact but readable
   - Installation:
     brew install --cask font-fira-code-nerd-font

3. Hack Nerd Font (MINIMAL ALTERNATIVE)
   - Why: No ligatures, pure monospace, SSH-friendly
   - Ligatures: None (by design)
   - Go benefits:
     * Maximum clarity, no ambiguity
     * Works perfectly over SSH
   - Installation:
     brew install --cask font-hack-nerd-font

================================================================================
TERMINAL CONFIGURATION
================================================================================

iTerm2:
  Preferences > Profiles > Text > Font
  - Set to: JetBrainsMono Nerd Font
  - Size: 13-14pt recommended
  - Ligatures: Check "Use ligatures" if desired
  - Anti-aliasing: Enabled

Alacritty (~/.config/alacritty/alacritty.toml):
  [font.normal]
  family = "JetBrainsMono Nerd Font"
  style = "Regular"

  [font.bold]
  family = "JetBrainsMono Nerd Font"
  style = "Bold"

  [font.italic]
  family = "JetBrainsMono Nerd Font"
  style = "Italic"

  [font]
  size = 13.0

Kitty (~/.config/kitty/kitty.conf):
  font_family      JetBrainsMono Nerd Font
  bold_font        auto
  italic_font      auto
  bold_italic_font auto
  font_size        13.0

  # Enable ligatures (optional)
  disable_ligatures never

WezTerm (~/.wezterm.lua):
  config.font = wezterm.font("JetBrainsMono Nerd Font")
  config.font_size = 13.0
  config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }  -- ligatures

================================================================================
LIGATURE CONSIDERATIONS FOR GO
================================================================================

Recommended ligature settings for Go development:

ENABLE these ligatures:
  - := (walrus operator) - very common in Go
  - -> (channel direction) - Go channels
  - == != (comparison) - subtle but helpful
  - <= >= (comparison)

CONSIDER DISABLING:
  - www (can look odd in URLs)
  - /* */ (comment markers, personal preference)

JetBrains Mono ligature control (in terminal):
  Most terminals let you selectively enable/disable ligatures.
  For Go, the defaults are usually fine.

================================================================================
SSH/TMUX COMPATIBILITY
================================================================================

When using Neovim over SSH or in tmux:

1. TMUX Configuration (~/.tmux.conf):
   set -g default-terminal "tmux-256color"
   set -ag terminal-overrides ",xterm-256color:RGB"

2. SSH with Font Fallback:
   If the remote doesn't have Nerd Fonts, icons will show as boxes.
   Solutions:
   a) Set NVIM_ICONS=0 before starting nvim:
      export NVIM_ICONS=0 && nvim

   b) Use the toggle command in Neovim:
      :IconsToggle
      or press <leader>ti

   c) Add to remote ~/.bashrc or ~/.zshrc:
      # Disable Neovim icons when no Nerd Font
      if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        export NVIM_ICONS=0
      fi

3. For best SSH experience:
   - Use Hack Nerd Font (no ligatures, maximum compatibility)
   - Or ensure your LOCAL terminal has the Nerd Font installed
     (icons render on your machine, not the remote)

================================================================================
VERIFYING FONT INSTALLATION
================================================================================

Run this in your terminal to verify Nerd Font icons work:
  echo -e "\ue702"  # Should show Go gopher icon
  echo -e "\uf015"  # Should show home icon
  echo -e "\uf121"  # Should show code icon

In Neovim, run:
  :lua print(require("config.icons").enabled and "Icons enabled" or "Icons disabled")

================================================================================
]]

-- Runtime font detection (informational only)
function M.check_nerd_font()
  -- Try to detect if we're likely in a Nerd Font environment
  local term = vim.env.TERM or ""
  local term_program = vim.env.TERM_PROGRAM or ""

  local likely_nerd_font = false

  -- Known good terminals that typically have Nerd Fonts configured
  if term_program:match("iTerm")
    or term_program:match("Alacritty")
    or term_program:match("kitty")
    or term_program:match("WezTerm") then
    likely_nerd_font = true
  end

  return likely_nerd_font
end

-- Display font check info
function M.info()
  local icons = require("config.icons")
  local lines = {
    "Font & Icon Status",
    string.rep("-", 40),
    "Icons enabled: " .. tostring(icons.enabled),
    "TERM: " .. (vim.env.TERM or "not set"),
    "TERM_PROGRAM: " .. (vim.env.TERM_PROGRAM or "not set"),
    "SSH session: " .. tostring(vim.env.SSH_CLIENT ~= nil),
    "Likely Nerd Font: " .. tostring(M.check_nerd_font()),
    "",
    "Commands:",
    "  :IconsToggle - Toggle icons on/off",
    "  <leader>ti   - Toggle icons keymap",
  }

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Font Info" })
end

-- User command
vim.api.nvim_create_user_command("FontInfo", function()
  M.info()
end, { desc = "Show font and icon configuration info" })

return M
