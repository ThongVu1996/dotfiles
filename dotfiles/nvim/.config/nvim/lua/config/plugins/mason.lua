return {
	-- Mason for managing LSP, linters, and formatters
	"mason-org/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" }, -- Load only when Mason command is used
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
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
				-- "html",
				-- "cssls",
				-- "tailwindcss",
				-- "svelte",
				-- "lua_ls",
				-- "graphql",
				-- "emmet_ls",
				-- "ts_ls",
				-- "pyright",
				-- "intelephense",
				-- "phpactor",
				"cspell-lsp", --cspell like vscode
				-- "vue-language-server",
				-- "vtls",
			},
			automatic_installation = true, -- Ensure automatic installation when needed
		})

		-- Ensure formatters, linters, and spell checkers are installed only when Mason is loaded
		mason_tool_installer.setup({
			ensure_installed = {
				-- "prettier", -- Formatter for JS/TS
				-- "stylua", -- Formatter for Lua
				-- "eslint_d", -- Linter for JS/TS
				-- "phpcs", -- PHP Code Sniffer
				-- "php-cs-fixer", -- PHP Code Style Fixer
				-- "black", -- Formatter for Python
				-- "debugpy",
			},
			auto_update = true, -- Update tools automatically
			run_on_start = false, -- Prevent running on Neovim start
		})

		-- Ensure MasonToolsInstall runs only when Mason is opened
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "mason",
			callback = function()
				vim.schedule(function()
					vim.cmd("MasonToolsInstall")
				end)
			end,
		})
	end,
}
