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

-- Draw virtual vertical guide (Virt-Column)
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
	callback = function()
		require("config.utils.ui").set_virt_column()
	end,
})

-- Enable native document color & keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.colorProvider then
			-- Enable native color highlighting (0.12+)
			vim.lsp.document_color.enable(true, { bufnr = args.buf }, { style = "virtual" })

			-- Keymap to switch color formats (Hex <-> RGB <-> HSL)
			vim.keymap.set("n", "<leader>cp", function()
				vim.lsp.document_color.color_presentation()
			end, { buffer = args.buf, desc = "LSP Color Presentation (Convert format)" })
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch", -- Highlight group (IncSearch is typically orange/yellow)
			timeout = 150, -- Duration of the highlight (ms)
		})
	end,
})