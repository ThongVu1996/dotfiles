local M = {}

--- Automatically open a buffer in a floating window using Snacks.win
--- @param bufnr number The buffer ID to open in the float
function M.open_float_win(bufnr)
	-- Ensure Snacks is available before proceeding
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return
	end

	-- Close the current window (usually the default split window)
	vim.api.nvim_command("wincmd c")

	-- Open the floating window with snack's UI engine
	snacks.win({
		buf = bufnr,
		width = 0.8,
		height = 0.8,
		border = "rounded",
		-- Add a nice dim effect to the background
		backdrop = 60,
		wo = {
			conceallevel = 2,
			colorcolumn = "",
		},
		keys = {
			q = "close", -- Press 'q' to close the window
		},
	})
end

return M
