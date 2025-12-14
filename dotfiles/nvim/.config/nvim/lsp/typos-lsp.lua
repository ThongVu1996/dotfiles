local blink = require("blink.cmp")

return {
	name = "typos-lsp",

	cmd = { "typos-lsp" },

	cmd_env = {
		RUST_LOG = "error",
	},

	filetypes = {
		"php",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"lua",
		"python",
		"markdown",
		"text",
	},

	root_markers = { ".git", ".typos.toml" },

	init_options = {
		-- ❗ đường dẫn config nếu có (optional)
		-- config = vim.fn.expand("~/.config/typos/typos.toml"),

		diagnosticSeverity = "Hint",
	},

	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
