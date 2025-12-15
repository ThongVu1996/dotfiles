return {
	"mason-org/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" }, -- Load only when Mason command is used
	config = function()
		local mason = require("mason")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		-- install cspell-lsp because nix search don't have
	end,
}
