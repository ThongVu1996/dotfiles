return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 1. Configure "Project-Aware" PHPStan
    -- This ensures we use the tool inside your project's vendor folder
    local phpstan = lint.linters.phpstan
    phpstan.cmd = function()
      local local_binary = vim.fn.getcwd() .. "/vendor/bin/phpstan"
      if vim.fn.executable(local_binary) == 1 then
        return local_binary
      end
      return "phpstan" -- Fallback to global if local doesn't exist
    end

    -- 2. Define Linters by Filetype
    lint.linters_by_ft = {
      -- Web Development (using fast daemons)
      javascript      = { "eslint_d" },
      typescript      = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte          = { "eslint_d" },

      -- Backend (Logic Analysis)
      php    = { "phpstan" },
      python = { "mypy", "pylint" },

      -- Nix Ecosystem
      nix = { "statix", "deadnix" },

      -- DevOps & Infrastructure (for your Proxmox/AWS lab)
      terraform = { "tflint", "tfsec" },
      tf        = { "tflint", "tfsec" },
      hcl       = { "tflint" },
    }

    -- 3. Automation Setup
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Use pcall to prevent crashing when notify arguments are malformed
        pcall(lint.try_lint)
      end,
    })

    -- 4. Keymap for Manual Check
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Check Code Logic (Lint)" })
  end,
}