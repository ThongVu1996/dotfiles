local blink = require("blink.cmp")

return {
	-- 1. Server execution command
	cmd = { "tailwindcss-language-server", "--stdio" },

	-- 2. Support for all Frontend files (including Blade for PHP)
	filetypes = {
		"javascript", "javascriptreact", "typescript", "typescriptreact",
		"vue", "svelte", "html", "blade", "css", "scss", "less", "postcss"
	},

	-- 3. Advanced Tailwind configurations
	settings = {
		tailwindCSS = {
			-- Show color preview on hover
			hovers = true,
			-- Smart suggestions with color icons
			suggestions = true,
			-- Show color decorators in the editor
			colorDecorators = true,
			-- Linting for utility classes
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			-- Auto-sorting logic (usually handled by Prettier, enabled here for enhanced suggestions)
			validate = true,
		},
	},

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
