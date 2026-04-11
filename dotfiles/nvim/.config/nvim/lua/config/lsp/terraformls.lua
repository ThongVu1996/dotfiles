local blink = require("blink.cmp")

return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars", "hcl" },
	root_markers = { ".terraform", ".git" },

	-- === FIX HERE ===
	-- Use vim.empty_dict() to send "{}" (Map) instead of "[]" (Slice).
	-- No path required, server will auto-find 'terraform' in the system.
	init_options = vim.empty_dict(),
	settings = vim.empty_dict(),
	-- ================

	on_attach = function(client, bufnr)
		-- Disable LSP formatting to give precedence to Conform (configured elsewhere)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
