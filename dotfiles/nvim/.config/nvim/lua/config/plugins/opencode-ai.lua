return {
	"NickvanDyke/opencode.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		vim.g.opencode_opts = {
			backend = "antigravity",
		}
		vim.o.autoread = true
		vim.g.opencode_opts = {
			backend = "antigravity",
			provider = {
				-- Using TMUX provider as you are in a tmux environment
				enabled = "tmux",
				tmux = {
					opens_in_pane = true, -- Open AI in a side pane
					cmd = "opencode",
					left = "25%", -- Pane size
				},
			},
		}
		local open = require("opencode")
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			open.ask("@this: ", { submit = false })
		end, { desc = "Ask AI" })
		vim.keymap.set({ "n", "x" }, "<leader>oc", function()
			open.select()
		end, { desc = "AI Actions" })
		vim.keymap.set({ "n", "t" }, "<leader>ot", function()
			open.toggle()
		end, { desc = "Toggle Chat" })
		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })
	end,
}
