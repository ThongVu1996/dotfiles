local blink = require("blink.cmp")

return {
	-- 1. Server execution command (Rust-based, extremely fast)
	cmd = { "markdown-oxide" },

	-- 2. Supported filetypes
	filetypes = { "markdown", "markdown.mdx" },

	-- 3. Root markers
	root_markers = { ".git", ".markdown-oxide.toml" },

	-- 4. Capabilities (Blink.cmp + Native LSP)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),

	-- 5. Oxide specific settings
	settings = {
		["markdown-oxide"] = {
			-- Obsidian-style wiki-links support
			wiki_links = {
				enable = true,
			},
		},
	},
}
