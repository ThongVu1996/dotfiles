vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.bo.fileformat = "unix"
	end,
})

-- Automatically open Help documentation in a floating window
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function(ev)
		require("config.utils.ui").open_float_win(ev.buf)
	end,
})
