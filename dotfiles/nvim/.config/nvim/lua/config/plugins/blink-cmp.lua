return {
	"saghen/blink.cmp",
	event = { "LspAttach" },
	dependencies = "rafamadriz/friendly-snippets",
	version = "v0.*",
	opts = {
		keymap = {
			-- ["<S-Tab>"] = { "select_prev", "fallback" },
			-- ["<Tab>"] = { "select_next", "fallback" },

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "snippets", "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
		completion = {
			documentation = {
				-- 1. Automatically show focus screen (True = Enable)
				auto_show = true,

				-- 2. Delay before showing (ms)
				-- 0 for instant, 200 to prevent flickering during rapid navigation
				auto_show_delay_ms = 200,

				-- 3. Window appearance configuration
				window = {
					border = "rounded", -- Rounded border for aesthetics (alt: "single", "double")
				},
			},

			-- Optional: List menu aesthetics
			menu = {
				border = "rounded",
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
		},
	},
}
