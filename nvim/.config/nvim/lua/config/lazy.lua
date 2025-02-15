local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugin_path = vim.fn.stdpath("config") .. "/plugin"
package.path = package.path .. ";" .. plugin_path .. "/?.lua"

require("lazy").setup({ { import = "config.plugins" }, { import = "config.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	rocks = {
		enabled = true,
		hererocks = false,
	},
	ui = {
		border = "rounded",
	},
})
