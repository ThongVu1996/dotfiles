return {
	-- Mason for managing LSP, linters, and formatters
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" }, -- Load only when Mason command is used
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- Configure Mason UI
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Ensure LSPs are installed only when Mason is loaded
		mason_lspconfig.setup({
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"volar",
				"ts_ls",
				"pyright",
				"intelephense",
				"phpactor",
			},
			automatic_installation = true, -- Ensure automatic installation when needed
		})

		-- Ensure formatters, linters, and spell checkers are installed only when Mason is loaded
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- Formatter for JS/TS
				"stylua", -- Formatter for Lua
				"eslint_d", -- Linter for JS/TS
				"phpcs", -- PHP Code Sniffer
				"php-cs-fixer", -- PHP Code Style Fixer
				"black", -- Formatter for Python
				"cspell", -- Code Spell Checker
				"misspell", -- English Misspelling Checker
				"codespell", -- Code Spell Checker
				"debugpy",
			},
			auto_update = true, -- Update tools automatically
			run_on_start = false, -- Prevent running on Neovim start
		})

		-- Ensure MasonToolsInstall runs only when Mason is opened
		vim.api.nvim_create_autocmd("User", {
			pattern = "MasonToolsUpdateCompleted",
			callback = function()
				vim.cmd("MasonToolsInstall") -- Runs only when Mason is opened
			end,
		})
	end,
}
