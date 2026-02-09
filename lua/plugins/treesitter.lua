-- Treesitter Configuration
-- Advanced syntax highlighting and code understanding

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "go", "gomod", "gosum", "gowork",
          "javascript", "typescript", "tsx", "vue",
          "html", "css", "scss", "json", "jsonc", "yaml", "toml",
          "lua", "luadoc", "vim", "vimdoc", "bash", "regex",
          "markdown", "markdown_inline",
          "gitcommit", "gitignore", "diff",
          "query", "sql", "graphql",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Treesitter text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
        swap = {},
      })

      -- Text object select keymaps
      local select = function(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end

      vim.keymap.set({ "x", "o" }, "af", select("@function.outer"), { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", select("@function.inner"), { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", select("@class.outer"), { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", select("@class.inner"), { desc = "Select inner class" })
      vim.keymap.set({ "x", "o" }, "aa", select("@parameter.outer"), { desc = "Select outer parameter" })
      vim.keymap.set({ "x", "o" }, "ia", select("@parameter.inner"), { desc = "Select inner parameter" })

      -- Move keymaps
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class start" })

      -- Swap keymaps
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sn", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>sp", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap previous parameter" })
    end,
  },

  -- Show code context (sticky header)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { enable = true, max_lines = 3 },
    keys = {
      { "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" },
    },
  },

  -- Automatically close and rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
