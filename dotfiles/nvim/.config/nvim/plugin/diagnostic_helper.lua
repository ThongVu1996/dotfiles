local M = {}

-- Change sign_define was deprecated in nvim 0.12
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
  virtual_text = { current_line = true },
})

function M.show_diagnostics(scope)
  local config = require("fzf-lua.config")
  local actions = require("trouble.sources.fzf").actions

  -- Attach the Trouble action and custom copy action to fzf-lua
  config.defaults.actions.files["ctrl-t"] = actions.open
  config.defaults.actions.files["ctrl-y"] = function(selected)
    if not selected or #selected == 0 then
      print("No diagnostic selected")
      return
    end

    -- Extract diagnostic message by splitting the selected line
    local diagnostic_entry = selected[1]
    local diagnostic_message = diagnostic_entry:match("^.-:%d+:%d+:%s(.+)")
    if diagnostic_message then
      vim.fn.setreg("+", diagnostic_message) -- Copy to clipboard
      print("Copied diagnostic: " .. diagnostic_message)
    else
      print("Failed to extract diagnostic message")
    end
  end

  -- Display diagnostics in fzf-lua based on scope
  if scope == "workspace" then
    require("fzf-lua").diagnostics_workspace({
      actions = config.defaults.actions.files,
      previewer = true,
    })
  elseif scope == "document" then
    require("fzf-lua").diagnostics_document({
      actions = config.defaults.actions.files,
      previewer = true,
    })
  end
end

return M
