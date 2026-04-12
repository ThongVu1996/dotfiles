return {
	"NickvanDyke/opencode.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		vim.g.opencode_opts = {
			backend = "antigravity",
			provider = {
				enabled = "tmux",
				tmux = { opens_in_pane = true, cmd = "opencode", left = "25%" },
			},
		}
		local open = require("opencode")
		vim.keymap.set({ "n", "x" }, "<leader>oa", function() open.ask("@this: ", { submit = false }) end, { desc = "Ask AI" })
		vim.keymap.set({ "n", "x" }, "<leader>oc", function() open.select() end, { desc = "AI Actions" })
		vim.keymap.set({ "n", "t" }, "<leader>ot", function() open.toggle() end, { desc = "Toggle Chat" })
	end,
}
