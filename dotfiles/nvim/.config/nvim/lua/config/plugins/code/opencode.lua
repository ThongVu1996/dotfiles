return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release

	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your optional configuration here
		}

		vim.o.autoread = true -- Required for `opts.events.reload` to work

		-- Tự động vào chế độ Gõ (Insert mode) khi focus vào cửa sổ Opencode
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			pattern = "term://*opencode*",
			callback = function()
				vim.cmd("startinsert")
			end,
		})

		-- 1. Basic keymaps (Using <leader>o to avoid conflicting with Vim motions)
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Opencode: Ask about code" })
		
		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			require("opencode").select()
		end, { desc = "Opencode: Open Actions Menu" })
		
		vim.keymap.set({ "n", "t" }, "<leader>oo", function()
			require("opencode").toggle()
		end, { desc = "Opencode: Toggle AI Window" })

		-- 2. Operator (Use 'go' with vim motions. E.g., goip to send a paragraph to AI)
		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Opencode: Send selected code to AI", expr = true })
		
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Opencode: Send current line to AI", expr = true })

		-- 3. Scroll AI window without focusing it (Using Vim-standard <leader>oj and <leader>ok)
		vim.keymap.set("n", "<leader>ok", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Opencode: Scroll AI window up" })
		
		vim.keymap.set("n", "<leader>oj", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Opencode: Scroll AI window down" })
	end,
}
