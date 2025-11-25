local M = {}

local signs = {
	Error = " ", -- Error symbol
	Warn = " ", -- Warning symbol
	Hint = " ", -- Hint (light bulb)
	Info = " ", -- Info symbol
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

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
