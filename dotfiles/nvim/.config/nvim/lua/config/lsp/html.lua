local blink = require("blink.cmp")

return {
	-- 1. Server execution command
	cmd = { "vscode-html-language-server", "--stdio" },

	-- 2. Only run on pure HTML and Templates (Avoid running on JS/TS to prevent conflicts with vtsls)
	filetypes = { "html", "templ", "blade" },

	-- 3. HTML specific capabilities configuration
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities(),
		{
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true,
					},
				},
			},
		}
	),

	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false -- Let Prettier (Conform) handle formatting
	end,
}
