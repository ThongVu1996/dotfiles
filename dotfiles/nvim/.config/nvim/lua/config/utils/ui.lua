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
--- @param symbol string? The symbol to use for the virtual column (defaults to "┆")
function M.set_virt_column(column, symbol)
	local bufnr = vim.api.nvim_get_current_buf()
	local winid = vim.api.nvim_get_current_win()
	
	-- Create a namespace dedicated to this window to support multiple splits
	local ns = vim.api.nvim_create_namespace("custom_virt_column_" .. winid)

	-- Use 80 as default or get from colorcolumn option
	column = column or tonumber(vim.wo.colorcolumn) or 80
	symbol = symbol or "┆"

	-- Clear previous virtual marks
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	if column <= 0 then
		return
	end

	-- Calculate offset for line numbers and sign column
	local wininfo = vim.fn.getwininfo(winid)[1]
	local offset = wininfo and wininfo.textoff or 0
	local target_col = column + offset - 1

	-- To avoid lag when calling this often (e.g. CursorMoved),
	-- we only get the lines that are currently visible on the screen.
	local first_line = vim.fn.line("w0")
	local last_line = vim.fn.line("w$")

	-- Place virtual text marks only on visible lines
	local lines = vim.api.nvim_buf_get_lines(bufnr, first_line - 1, last_line, false)
	for i, line in ipairs(lines) do
		-- Line number is 1-indexed for Vim functions
		local lnum = first_line + i - 1
		
		-- Skip folded lines because their foldtext might extend past the column
		if vim.fn.foldclosed(lnum) == -1 then
			-- Only draw the guide if the line is shorter than the target column
			-- to prevent it from overlaying and hiding real characters
			if vim.fn.strdisplaywidth(line) < column then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
					virt_text = { { symbol, "Comment" } },
					virt_text_win_col = target_col,
					priority = 10,
				})
			end
		end
	end
end

return M
