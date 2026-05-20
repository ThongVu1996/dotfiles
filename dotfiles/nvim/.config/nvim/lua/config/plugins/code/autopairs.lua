-- return {
-- 	"windwp/nvim-autopairs",
-- 	event = { "InsertEnter" },
-- 	dependencies = {
-- 		"saghen/blink.cmp",
-- 	},
-- 	config = function()
-- 		require("nvim-autopairs").setup({
-- 			check_ts = true,
-- 			ts_config = {
-- 				lua = { "string" },
-- 				javascript = { "template_string" },
-- 				java = false,
-- 			},
-- 		})
-- 	end,
-- }


return {
	"saghen/blink.pairs",
	version = "*", -- Bắt buộc để tải bản build sẵn
	event = "InsertEnter",
	dependencies = {
		"saghen/blink.download",
	},
	opts = {
		mappings = {
			enabled = true,
			cmdline = true,
		},
		highlights = {
			enabled = true,
			cmdline = true,
		},
	},
}
