return {
  "folke/trouble.nvim",
  dependencies = {
    -- "nvim-tree/nvim-web-devicons", -- For icons
    "folke/todo-comments.nvim", -- Optional dependency for TODOs
  },
  opts = {
    focus = true, -- Focus Trouble when opened
  },
  config = function()
    -- Configure diagnostics globally using vim.diagnostic.config
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Customize virtual text prefix
      },
      signs = {
        active = {
          { name = "DiagnosticSignError", text = "✗" },
          { name = "DiagnosticSignWarn", text = "⚠" },
          { name = "DiagnosticSignInfo", text = "ℹ" },
          { name = "DiagnosticSignHint", text = "➤" },
        },
      },
      underline = true, -- Underline diagnostics
      update_in_insert = false, -- Do not update diagnostics in insert mode
      severity_sort = true, -- Sort diagnostics by severity
    })

    -- Setup Trouble.nvim with diagnostics signs
    require("trouble").setup({
      use_diagnostic_signs = true, -- Use the diagnostic signs defined above
    })
  end,
  cmd = "Trouble", -- Lazy-load Trouble on the Trouble command
  keys = {
    { "<leader>xw", "<cmd>Trouble workspace_diagnostics<CR>", desc = "Open Trouble workspace diagnostics" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xd", "<cmd>Trouble document_diagnostics<CR>", desc = "Open Trouble document diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix<CR>", desc = "Open Trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist<CR>", desc = "Open Trouble location list" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open TODOs in Trouble" },
  },
}
