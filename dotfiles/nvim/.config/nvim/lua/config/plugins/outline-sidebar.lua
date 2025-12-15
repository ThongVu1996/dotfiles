return {
	dir = vim.fn.stdpath("config"),
	name = "outline-sidebar",
	lazy = true,
	keys = {
		{
			"<leader>oo",
			function()
				require("modules.outline").toggle()
			end,
			mode = "n",
			desc = "Toggle Outline Sidebar",
		},
	},

	config = function()
		-- 1. Yêu cầu module chính (tự động tìm init.lua)
		local core = require("modules.outline")

		-- 2. Thiết lập keymap toàn cục
		-- Đường dẫn là: lua/modules/outline/config.lua
		local CONFIG = require("modules.outline.config")

		vim.keymap.set("n", CONFIG.keymap_toggle, function()
			core.toggle()
		end, { desc = "Toggle Outline" })

		-- 3. Khởi tạo Auto Commands
		core.setup_autocmds()
	end,
}
