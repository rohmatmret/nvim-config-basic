-- UI Enhancements
-- Colorscheme, statusline, bufferline, and notifications

return {
  -- Colorscheme: Tokyonight (optimized for Go development)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- storm, moon, night, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree", "terminal", "trouble" },
      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,
      cache = true, -- Enable caching for better performance
      plugins = {
        auto = true, -- Auto-detect plugins via lazy.nvim
      },
      on_colors = function(colors)
        -- Slightly adjust colors for better Go readability
        colors.hint = colors.teal
        colors.error = "#db4b4b"
      end,
      on_highlights = function(hl, c)
        -- Go-specific semantic token highlights
        hl["@lsp.type.interface.go"] = { fg = c.cyan, italic = true }
        hl["@lsp.type.struct.go"] = { fg = c.blue1 }
        hl["@lsp.type.property.go"] = { fg = c.blue2 }
        hl["@lsp.type.method.go"] = { fg = c.blue, bold = true }
        hl["@lsp.type.parameter.go"] = { fg = c.yellow }
        hl["@lsp.type.type.go"] = { fg = c.cyan }

        -- Better visibility for diagnostics
        hl.DiagnosticVirtualTextError = { bg = c.none, fg = c.error }
        hl.DiagnosticVirtualTextWarn = { bg = c.none, fg = c.warning }
        hl.DiagnosticVirtualTextInfo = { bg = c.none, fg = c.info }
        hl.DiagnosticVirtualTextHint = { bg = c.none, fg = c.hint }

        -- Neo-tree dim text for vendor directories
        hl.NeoTreeDimText = { fg = c.comment }

        -- Telescope improvements
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.border_highlight }
        hl.TelescopePromptNormal = { bg = c.bg_dark }
        hl.TelescopePromptBorder = { bg = c.bg_dark, fg = c.border_highlight }
        hl.TelescopePromptTitle = { bg = c.blue, fg = c.bg_dark }
        hl.TelescopePreviewTitle = { bg = c.green, fg = c.bg_dark }
        hl.TelescopeResultsTitle = { bg = c.magenta, fg = c.bg_dark }

        -- Float borders
        hl.FloatBorder = { fg = c.border_highlight, bg = c.bg_float }
        hl.NormalFloat = { bg = c.bg_float }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local icons = require("config.icons")
      local diag = icons.category("diagnostics")
      local git = icons.category("git")
      local ui = icons.category("ui")

      -- Go-specific statusline component
      local function go_status()
        if vim.bo.filetype ~= "go" then
          return ""
        end
        -- Show if in a Go module
        local go_mod = vim.fn.findfile("go.mod", ".;")
        if go_mod ~= "" then
          return icons.enabled and " " or "[Go]"
        end
        return ""
      end

      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
          },
          component_separators = icons.enabled and { left = "", right = "" } or { left = "|", right = "|" },
          section_separators = icons.enabled and { left = "", right = "" } or { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              icon = icons.enabled and "" or "@",
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = diag.error or "E",
                warn = diag.warn or "W",
                hint = diag.hint or "H",
                info = diag.info or "I",
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
              cond = function()
                return icons.enabled
              end,
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = icons.enabled and "  " or " [+]",
                readonly = icons.enabled and " " or " [RO]",
                unnamed = "[No Name]",
              },
            },
            -- Go module indicator
            {
              go_status,
              cond = function()
                return vim.bo.filetype == "go"
              end,
              color = { fg = "#7aa2f7" },
            },
          },
          lualine_x = {
            -- Noice command status
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
            },
            -- Noice mode status
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
            },
            -- LSP status (useful for gopls)
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                  return ""
                end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return (icons.enabled and " " or "[LSP:") .. table.concat(names, ",") .. (icons.enabled and "" or "]")
              end,
              cond = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
              end,
              color = { fg = "#7aa2f7" },
            },
            -- Git diff
            {
              "diff",
              symbols = {
                added = git.added or "+",
                modified = git.modified or "~",
                removed = git.removed or "-",
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return (icons.enabled and " " or "") .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy", "trouble" },
      }
    end,
  },

  -- Bufferline (tab-like buffer display)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = function()
      local icons_module = require("config.icons")
      local diag_icons = icons_module.category("diagnostics")

      return {
        options = {
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          show_buffer_icons = icons_module.enabled,
          diagnostics_indicator = function(_, _, diag)
            local icons = {
              error = diag_icons.error or "E",
              warning = diag_icons.warn or "W",
              hint = diag_icons.hint or "H",
              info = diag_icons.info or "I",
            }
            local ret = (diag.error and icons.error .. diag.error .. " " or "")
              .. (diag.warning and icons.warning .. diag.warning or "")
            return vim.trim(ret)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = icons_module.enabled and "  File Explorer" or "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
          -- Go-specific: show test files distinctly
          custom_filter = function(buf_number, _)
            -- Always show the buffer
            return true
          end,
        },
      }
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

  -- Noice (better UI for messages, cmdline, popupmenu)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+Noice" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade",
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- Better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local icons = require("config.icons")
      local ui = icons.category("ui")

      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      -- Use icons from centralized config with fallbacks
      dashboard.section.buttons.val = {
        dashboard.button("f", (ui.find or "F") .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", (ui.new_file or "N") .. " New file", "<cmd>ene<bar>startinsert<cr>"),
        dashboard.button("r", (ui.recent or "R") .. " Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", (ui.search or "G") .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", (ui.cog or "C") .. " Config", "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("l", (ui.lazy or "L") .. " Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", (ui.quit or "Q") .. " Quit", "<cmd>qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      require("alpha").setup(dashboard.opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Icons (nvim-web-devicons with Go-specific configuration)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = function()
      local icons = require("config.icons")
      if not icons.enabled then
        return { default = true }
      end

      -- Tokyonight storm colors (theme-aligned)
      local colors = {
        go = "#7aa2f7",       -- Tokyonight blue (Go gopher)
        go_mod = "#9ece6a",   -- Tokyonight green
        go_sum = "#bb9af7",   -- Tokyonight purple
        go_test = "#f7768e",  -- Tokyonight red (tests)
        vendor = "#565f89",   -- Tokyonight comment gray
        generated = "#565f89",-- Tokyonight comment gray
        tmpl = "#e0af68",     -- Tokyonight yellow
      }

      return {
        default = true,
        strict = true,
        -- Go-specific file icons
        override_by_filename = {
          ["go.mod"] = {
            icon = "",
            color = colors.go_mod,
            name = "GoMod",
          },
          ["go.sum"] = {
            icon = "",
            color = colors.go_sum,
            name = "GoSum",
          },
          ["go.work"] = {
            icon = "",
            color = colors.go,
            name = "GoWork",
          },
          [".golangci.yml"] = {
            icon = "",
            color = colors.go,
            name = "GolangciLint",
          },
          [".golangci.yaml"] = {
            icon = "",
            color = colors.go,
            name = "GolangciLint",
          },
          ["Makefile"] = {
            icon = "",
            color = "#6d8086",
            name = "Makefile",
          },
          ["Dockerfile"] = {
            icon = "󰡨",
            color = "#458ee6",
            name = "Dockerfile",
          },
          [".env"] = {
            icon = "",
            color = "#faf743",
            name = "Env",
          },
          [".env.example"] = {
            icon = "",
            color = "#faf743",
            name = "EnvExample",
          },
        },
        -- Extension-based overrides
        override_by_extension = {
          ["go"] = {
            icon = "",
            color = colors.go,
            name = "Go",
          },
          ["templ"] = {
            icon = "",
            color = colors.tmpl,
            name = "Templ",
          },
          ["proto"] = {
            icon = "",
            color = "#7aa2f7",
            name = "Proto",
          },
        },
        -- Pattern matching for test files
        override = {
          -- Default go icon (will be used as base)
          go = {
            icon = "",
            color = colors.go,
            name = "Go",
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },
}
