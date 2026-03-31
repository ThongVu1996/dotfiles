vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Kích hoạt Native Inlay Hints cho các Server có hỗ trợ
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		-- Đã gỡ bỏ <leader>fm ở đây để ưu tiên dùng conform.nvim làm formatter
	end,
})

return true
