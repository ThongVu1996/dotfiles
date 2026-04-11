return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = {
		"saghen/blink.cmp", -- Ensure blink.cmp is loaded first
	},
	config = function()
		-- Import nvim-autopairs
		local autopairs = require("nvim-autopairs")

		-- Configure autopairs
		autopairs.setup({
			check_ts = true, -- Enable Treesitter integration
			ts_config = {
				lua = { "string" }, -- Don't add pairs in Lua string treesitter nodes
				javascript = { "template_string" }, -- Don't add pairs in JS template_string nodes
				java = false, -- Disable Treesitter check for Java
			},
		})
	end,
}
