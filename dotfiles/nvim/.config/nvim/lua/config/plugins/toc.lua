return {
	dir = vim.fn.stdpath("config") .. "/lua/modules/toc",
	name = "vscode-strict-toc",
	ft = "markdown",
	config = function()
		require("modules.toc.vscode_strict_toc").setup()
	end,
}
