return {
  "yioneko/nvim-vtsls",
  ft = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  keys = {
    { "<leader>ty", "<cmd>VtsExec add_missing_types<CR>", desc = "LSP: Add missing types" },
    { "<leader>fa", "<cmd>VtsExec fix_all<CR>", desc = "LSP: Fix all diagnostics" },
  },
  config = function()
    require("vtsls").config({
      refactor_auto_rename = true,
      expose_as_code_action = "all",
    })
  end,
}
