return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- Web & Markup (Using prettierd for instant speed)
        javascript      = { "prettierd" },
        typescript      = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte          = { "prettierd" },
        css             = { "prettierd" },
        html            = { "prettierd" },
        json            = { "prettierd" },
        yaml            = { "prettierd" },
        markdown        = { "prettierd" },
        graphql         = { "prettierd" },
        liquid          = { "prettierd" },

        -- Backend & Config
        lua  = { "stylua" },
        php  = { "pint" }, -- Official Laravel style
        nix  = { "alejandra" },

        -- Infrastructure
        terraform = { "terraform_fmt" },
        tf        = { "terraform_fmt" },
        hcl       = { "packer_fmt" },
      },

      -- Auto-format when you save the file
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    -- Manual format shortcut (Works in Normal and Visual mode)
    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format Code" })
  end,
}