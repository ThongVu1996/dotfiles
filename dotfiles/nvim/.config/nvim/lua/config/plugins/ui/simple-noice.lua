return {
	"ThongVu1996/simple-noice.nvim",
	-- event = "VeryLazy",
	-- dir = "/Users/thongvu/nix-config/git-plugin-nvim/simple-noice.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		keymaps = {
			confirm = "<Tab>", -- Execute command or accept blink suggestion
		},
	},
	config = function(_, opts)
		require("simple-noice").setup(opts)
	end,

	-- dir = "/Users/thongvu/nix-config/git-plugin-nvim/simple-noice.nvim",
	-- name = "simple-noice", -- Đặt tên định danh thay vì repo path
	-- event = { "BufReadPost", "BufNewFile" },
	-- opts = {
	--     messages = {
	--         enabled = true,
	--     },
	-- keymaps = {
	-- 	confirm = "<Tab>", -- Execute command or accept blink suggestion
	-- 	close = "<Esc>", -- Close the floating window
	-- 	history_up = "<Up>", -- Navigate up in history
	-- 	history_down = "<Down>", -- Navigate down in history
	-- },
	-- },
	-- config = function(_, opts)
	-- require("simple-noice").setup(opts)
	-- end,
}
