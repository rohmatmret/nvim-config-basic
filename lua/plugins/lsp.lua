-- LSP Configuration
-- Comprehensive setup for Go, TypeScript, JavaScript, Vue

return {
  -- Mason: LSP/DAP/Linter/Formatter installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        -- Go
        "gopls",
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "staticcheck",
        "delve",
        -- TypeScript/JavaScript
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        -- Vue
        "vue-language-server",
        -- General
        "lua-language-server",
        "stylua",
        "json-lsp",
        "yaml-language-server",
        "tailwindcss-language-server",
        "css-lsp",
        "html-lsp",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      -- Auto-install ensure_installed packages
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Mason-lspconfig: Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    version = "v2.*", -- Pin to v2.x to avoid deprecation warnings
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- Neovim Lua API completion (replaces neodev)
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress indicator
    },
    config = function()
      -- LSP attach callback
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConfig", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Keymaps
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          -- Navigation
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "Go to references")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

          -- Information
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Actions
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format document")
          map("v", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format selection")

          -- Workspace
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")

          -- Inlay hints (Neovim 0.10+)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Toggle inlay hints")
          end

          -- Document highlight on cursor hold
          if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- LSP handlers UI
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Capabilities with nvim-cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Server configurations
      local lspconfig = require("lspconfig")

      -- Go (gopls) - Full configuration
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true, -- Use gofumpt formatting
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true, -- Enable staticcheck
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.venv", "-node_modules" },
            semanticTokens = true,
          },
        },
      })

      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- ESLint
      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Vue (Volar)
      lspconfig.volar.setup({
        capabilities = capabilities,
        filetypes = { "vue" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
          },
        },
      })

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })
    end,
  },

  -- SchemaStore for JSON/YAML schemas
  { "b0o/schemastore.nvim", lazy = true },

  -- Format on save with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" }, -- goimports for imports, gofumpt for formatting
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },

  -- Linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "staticcheck" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        vue = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("Linting", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
