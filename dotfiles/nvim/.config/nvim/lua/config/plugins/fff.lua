return {
	-- Quay lại dùng dmtrKovalenko/fff.nvim để ổn định tuyệt đối
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			require("fff.download").download_or_build_binary()
		end,
		lazy = false,
		opts = {
			base_path = vim.fn.getcwd(),
			prompt = "    ",
			title = " FFFinder ",
			layout = {
				height = 0.8,
				width = 0.9,
				prompt_position = "top",
				preview_position = "right",
				preview_size = 0.55, -- Tăng kích thước preview cho dễ nhìn
				show_scrollbar = true,
			},
			preview = {
				enabled = true,
				max_size = 10 * 1024 * 1024,
				line_numbers = true,
				wrap_lines = false,
			},
			keymaps = {
				preview_scroll_up = "<C-u>",
				preview_scroll_down = "<C-d>",
				focus_list = "<leader>l",
				focus_preview = "<leader>p",
			},
			git = {
				status_text_color = true,
			},
		},
		config = function(_, opts)
			require("fff").setup(opts)
		end,
		keys = {
			{
				"<leader><space>",
				function()
					require("fff").find_files()
				end,
				desc = "FFF: Smart Find Files",
			},
			{
				"<leader>ff",
				function()
					require("fff").find_files()
				end,
				desc = "FFF: Find Files",
			},
			{
				"<leader>fg",
				function()
					require("fff").live_grep()
				end,
				desc = "FFF: Live Grep",
			},
			{
				"<leader>fs",
				function()
					require("fff").live_grep({
						grep = {
							modes = { "fuzzy", "plain" },
						},
					})
				end,
				desc = "FFF: Live Fuzzy Grep",
			},
			{
				"<leader>sw",
				function()
					require("fff").live_grep({ query = vim.fn.expand("<cword>") })
				end,
				desc = "FFF: Search Current Word",
			},
		},
	},
}
