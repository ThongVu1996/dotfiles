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

--- Draws a virtual vertical guide at a fixed column
--- @param column number? The column position (defaults to 80 or colorcolumn value)
function M.set_virt_column(column)
	local ns = vim.api.nvim_create_namespace("custom_virt_column")
	local bufnr = vim.api.nvim_get_current_buf()
	local winid = vim.api.nvim_get_current_win()

	-- Use 80 as default or get from colorcolumn option
	column = column or tonumber(vim.wo.colorcolumn) or 80

	-- Clear previous virtual marks
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	if column <= 0 then
		return
	end

	-- Calculate offset for line numbers and sign column
	local wininfo = vim.fn.getwininfo(winid)[1]
	local offset = wininfo and wininfo.textoff or 0
	local target_col = column + offset - 1

	-- Place virtual text marks on all existing lines
	local last_line = vim.api.nvim_buf_line_count(bufnr)
	for i = 0, last_line - 1 do
		vim.api.nvim_buf_set_extmark(bufnr, ns, i, 0, {
			virt_text = { { "┆", "Comment" } },
			virt_text_win_col = target_col,
			priority = 10,
		})
	end
end

return M
