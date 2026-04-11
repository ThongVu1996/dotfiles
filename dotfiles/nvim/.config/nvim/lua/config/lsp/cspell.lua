local blink = require("blink.cmp")

return {
	cmd = { "cspell-lsp", "--stdio" },

	filetypes = {
		"lua",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"rust",
		"go",
		"python",
		"php",
		"html",
		"css",
		"json",
		"markdown",
		"text",
		"gitcommit",
	},

	root_markers = { "cspell.json", ".cspell.json", "package.json", ".git" },

	settings = {
		cSpell = {
			enabled = true,
			checkOnlyEnabledFileTypes = false,
		},
	},

	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
