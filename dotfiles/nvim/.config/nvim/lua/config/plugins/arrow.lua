return {
	"otavioschwanck/arrow.nvim",
	keys = { "\t", "m" },
	dependencies = {
		{ "echasnovski/mini.icons" },
	},
	opts = {
		show_icons = true,
		leader_key = "\t", -- Recommended to be a single key, e.g Tab
		buffer_leader_key = "m", -- Per Buffer Mappings
	},
}
