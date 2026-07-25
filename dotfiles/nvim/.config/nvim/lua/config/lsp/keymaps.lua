vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Enable Native Inlay Hints for supported servers
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		if client and client.name == "phpactor" then
			client.server_capabilities.completionProvider = false
			client.server_capabilities.diagnosticProvider = false
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.definitionProvider = false
		end

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

return true
