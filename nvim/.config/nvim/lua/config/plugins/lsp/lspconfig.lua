return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "Saghen/blink.cmp",
    -- Auto update reference when change name file, name variable
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- Enhance LSP for lua
    { "folke/neodev.nvim", opts = {} },
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")

    -- Configure Blink CMP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          relativePatternSupport = true,
        },
      },
    })

    -- Example using opts for defining servers
    local servers = {
      phpactor = {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("composer.json", ".git") or vim.loop.cwd(),
      },
      intelephense = {
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = { maxSize = 5000000 },
          },
        },
      },
      ts_ls = {
        capabilities = capabilities,
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false -- Prettier formatting
        end,
      },
      volar = {
        capabilities = capabilities,
        filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "html", "css", "typescriptreact", "javascriptreact", "vue" },
      },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        typos_lsp = {
          cmd = { "typos-lsp" }, -- Đảm bảo rằng `typos-lsp` đã được cài đặt và có trong PATH
          filetypes = {
            "markdown", -- Markdown
            "text", -- Plain text
            "gitcommit", -- Git commit messages
            "php", -- PHP files
            "javascript", -- JavaScript
            "typescript", -- TypeScript
            "javascriptreact", -- JSX
            "typescriptreact", -- TSX
            "vue", -- Vue.js
            "html", -- HTML
            "css", -- CSS
          },
          root_dir = lspconfig.util.root_pattern(".git", vim.loop.cwd()), -- Thư mục root
          capabilities = capabilities,
        },
      },
    }

    -- Setup LSP servers using the updated capabilities from Blink CMP
    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Customize virtual text prefix
      },
      signs = {
        active = {
          { name = "DiagnosticSignError", text = "" },
          { name = "DiagnosticSignWarn", text = "" },
          { name = "DiagnosticSignHint", text = "󰠠" },
          { name = "DiagnosticSignInfo", text = "" },
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    -- Force type for php
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.php",
      command = "LspStart phpactor",
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap = vim.keymap.set
        local opts = { buffer = ev.buf, silent = true }

        -- Tìm tham chiếu
        opts.desc = "Find references"
        keymap("n", "gR", vim.lsp.buf.references, opts)

        -- Đi tới khai báo
        opts.desc = "Go to declaration"
        keymap("n", "gD", vim.lsp.buf.declaration, opts)

        -- Đi tới định nghĩa
        opts.desc = "Find definitions"
        keymap("n", "gd", vim.lsp.buf.definition, opts)

        -- Tìm các implementation
        opts.desc = "Find implementations"
        keymap("n", "gi", vim.lsp.buf.implementation, opts)

        -- Tìm type definitions
        opts.desc = "Find type definitions"
        keymap("n", "gt", vim.lsp.buf.type_definition, opts)

        -- Thao tác code
        opts.desc = "Code actions"
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Đổi tên symbol
        opts.desc = "Rename symbol"
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- Xem diagnostics của buffer
        opts.desc = "Buffer diagnostics"
        keymap("n", "<leader>D", function()
          vim.diagnostic.setqflist({ open = true })
        end, opts)

        -- Xem diagnostics của workspace
        opts.desc = "Workspace diagnostics"
        keymap("n", "<leader>wD", function()
          vim.diagnostic.setqflist({ open = true, workspace = true })
        end, opts)

        -- Xem diagnostic hiện tại
        opts.desc = "Line diagnostics"
        keymap("n", "<leader>d", vim.diagnostic.open_float, opts)

        -- Diagnostic trước
        opts.desc = "Previous diagnostic"
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)

        -- Diagnostic tiếp theo
        opts.desc = "Next diagnostic"
        keymap("n", "]d", vim.diagnostic.goto_next, opts)

        -- Tài liệu hover
        opts.desc = "Hover documentation"
        keymap("n", "K", vim.lsp.buf.hover, opts)

        -- Restart LSP
        opts.desc = "Restart LSP"
        keymap("n", "<leader>rs", ":LspRestart<CR>", opts)

        -- Format tài liệu
        opts.desc = "Format document"
        keymap("n", "<leader>fd", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end,
    })
  end,
}
