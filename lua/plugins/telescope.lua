-- Telescope Configuration
-- Fuzzy finder for files, text, and more

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- Files
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

      -- Search
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep (live)" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },

      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },

      -- LSP
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>lD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },

      -- Misc
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>ft", "<cmd>Telescope filetypes<cr>", desc = "File types" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Vim options" },
      { "<leader>f/", "<cmd>Telescope search_history<cr>", desc = "Search history" },
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command history" },

      -- Resume
      { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local icons = require("config.icons")

      -- Dynamic prompt based on icon availability
      local prompt_prefix = icons.enabled and "   " or "> "
      local selection_caret = icons.enabled and "  " or "* "
      local entry_prefix = icons.enabled and "  " or "  "

      return {
        defaults = {
          prompt_prefix = prompt_prefix,
          selection_caret = selection_caret,
          entry_prefix = entry_prefix,
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "%.lock",
            "%-lock.json",
            "%.min.js",
            "%.min.css",
            "dist/",
            "build/",
            "vendor/",
            ".cache/",
          },
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<M-p>"] = action_layout.toggle_preview,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<M-p>"] = action_layout.toggle_preview,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
            -- Show Go files with proper icons
            previewer = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "-g", "!.git" }
            end,
            -- Go-specific grep (exclude vendor by default, can be toggled)
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            previewer = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["d"] = actions.delete_buffer,
              },
            },
          },
          -- LSP pickers optimized for Go
          lsp_references = {
            show_line = true,
          },
          lsp_definitions = {
            show_line = true,
          },
          lsp_implementations = {
            show_line = true,
          },
          -- Git pickers with icons
          git_commits = {
            previewer = true,
          },
          git_status = {
            previewer = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
