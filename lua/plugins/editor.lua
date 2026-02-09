-- Editor Enhancements
-- File explorer, which-key, comments, and more

return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in file explorer" },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      -- Hijack netrw when opening a directory
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = function()
      local icons = require("config.icons")
      local ui_icons = icons.category("ui")
      local git_icons = icons.category("git")
      local tree_icons = icons.category("tree")
      local file_icons = icons.category("files")

      return {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
        -- Muted diagnostic icons (subtle, non-distracting)
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = tree_icons.expander_collapsed or "",
            expander_expanded = tree_icons.expander_expanded or "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            folder_empty_open = "",
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              added = git_icons.added or "+",
              modified = git_icons.modified or "~",
              deleted = git_icons.removed or "-",
              renamed = git_icons.renamed or "R",
              untracked = git_icons.untracked or "?",
              ignored = git_icons.ignored or "!",
              unstaged = git_icons.unstaged or "U",
              staged = git_icons.staged or "S",
              conflict = git_icons.conflict or "C",
            },
          },
          diagnostics = {
            symbols = {
              hint = icons.get("diagnostics", "hint"),
              info = icons.get("diagnostics", "info"),
              warn = icons.get("diagnostics", "warn"),
              error = icons.get("diagnostics", "error"),
            },
            highlights = {
              hint = "DiagnosticSignHint",
              info = "DiagnosticSignInfo",
              warn = "DiagnosticSignWarn",
              error = "DiagnosticSignError",
            },
          },
        },
        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<space>"] = "none",
            ["<cr>"] = "open",
            ["o"] = "open",
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = { "add", config = { show_path = "relative" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          },
        },
        filesystem = {
          bind_to_cwd = true,
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
          hijack_netrw_behavior = "open_current", -- Open neo-tree when opening a directory
          -- Go-optimized filtering
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules",
              ".git",
            },
            -- Show vendor but dimmed (important for Go)
            hide_by_pattern = {},
            always_show = {
              "vendor",
              ".golangci.yml",
              ".golangci.yaml",
            },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
          },
          -- Custom component for Go files
          components = {
            -- Dim vendor directory files
            name = function(config, node, state)
              local name = node.name or ""
              local path = node.path or ""
              local highlight = "NeoTreeFileName"
              -- Dim vendor directory
              if path:match("/vendor/") then
                highlight = "NeoTreeDimText"
              end
              -- Dim generated files (common Go patterns)
              if name:match("%.pb%.go$") or name:match("_gen%.go$") or name:match("_generated%.go$") then
                highlight = "NeoTreeDimText"
              end
              return {
                text = name,
                highlight = highlight,
              }
            end,
          },
        },
        buffers = {
          follow_current_file = { enabled = true },
          group_empty_dirs = true,
          show_unloaded = true,
        },
        git_status = {
          window = {
            position = "float",
          },
        },
      }
    end,
  },

  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons")
      local ui = icons.category("ui")

      return {
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        icons = {
          breadcrumb = ui.breadcrumb or ">",
          separator = ui.separator or "->",
          group = ui.group or "+",
          -- Disable icons in keys if not using Nerd Fonts
          mappings = icons.enabled,
          keys = icons.enabled and {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            D = "󰘳 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "󰁮 ",
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫 ",
            F2 = "󱊬 ",
            F3 = "󱊭 ",
            F4 = "󱊮 ",
            F5 = "󱊯 ",
            F6 = "󱊰 ",
            F7 = "󱊱 ",
            F8 = "󱊲 ",
            F9 = "󱊳 ",
            F10 = "󱊴 ",
            F11 = "󱊵 ",
            F12 = "󱊶 ",
          } or {},
        },
        win = {
          border = "rounded",
          padding = { 2, 2, 2, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        show_help = true,
        show_keys = true,
      }
    end,
    config = function(_, opts)
      local wk = require("which-key")
      local icons = require("config.icons")
      wk.setup(opts)

      -- Group icons (subtle, muted)
      local group_icons = icons.enabled and {
        buffer = " ",
        code = " ",
        find = " ",
        git = " ",
        lsp = " ",
        quit = " ",
        search = " ",
        toggle = " ",
        window = " ",
        tab = "󰓩 ",
        debug = " ",
        test = " ",
      } or {}

      wk.add({
        { "<leader>b", group = (group_icons.buffer or "") .. "Buffer" },
        { "<leader>c", group = (group_icons.code or "") .. "Code" },
        { "<leader>d", group = (group_icons.debug or "") .. "Debug" },
        { "<leader>f", group = (group_icons.find or "") .. "Find/File" },
        { "<leader>g", group = (group_icons.git or "") .. "Git" },
        { "<leader>l", group = (group_icons.lsp or "") .. "LSP" },
        { "<leader>q", group = (group_icons.quit or "") .. "Quit" },
        { "<leader>s", group = (group_icons.search or "") .. "Search/Swap" },
        { "<leader>t", group = (group_icons.toggle or "") .. "Toggle" },
        { "<leader>w", group = (group_icons.window or "") .. "Window" },
        { "<leader>x", group = (group_icons.code or "") .. "Diagnostics" },
        { "<leader><tab>", group = (group_icons.tab or "") .. "Tab" },
      })
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Better text objects
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  -- Flash for quick navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Improved marks
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    },
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

  -- Trouble for diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = function()
      local icons = require("config.icons")
      local diag = icons.category("diagnostics")
      local ui = icons.category("ui")
      local kinds = icons.category("kinds")

      return {
        auto_close = true,
        auto_preview = false,
        focus = true,
        icons = {
          indent = {
            top = "│ ",
            middle = "├╴",
            last = "└╴",
            fold_open = ui.arrow_down or "v ",
            fold_closed = ui.arrow_right or "> ",
            ws = "  ",
          },
          folder_closed = icons.get("files", "folder_closed"),
          folder_open = icons.get("files", "folder_open"),
          kinds = icons.enabled and kinds or {},
        },
        modes = {
          diagnostics = {
            groups = {
              { "filename", format = "{file_icon} {basename:Title} {count}" },
            },
          },
          symbols = {
            groups = {
              { "filename", format = "{file_icon} {basename:Title} {count}" },
            },
            filter = {
              -- Filter out less useful symbols for Go
              ["not"] = {
                kind = { "Variable", "Constant" },
              },
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- Context commentstring for JSX/TSX
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
}
