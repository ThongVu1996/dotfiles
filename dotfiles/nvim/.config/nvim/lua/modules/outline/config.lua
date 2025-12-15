local M = {
	width = 30,
	keymap_toggle = "<leader>oo",
	keymap_preview = "p",
	keymap_search = "/",

	preview = {
		width_pct = 0.5,
		height_pct = 0.6,
		border = "rounded",
	},

	-- Danh sách các loại cửa sổ Explorer cần tự động đóng khi mở Outline
	explorer_filetypes = {
		"snacks_picker_list",
		"snacks_picker_input",
		"snacks_dashboard",
		"neo-tree",
		"NvimTree",
		"oil",
	},

	-- Buffer cần bỏ qua (để tránh lỗi crash)
	ignore_filetypes = {
		"snacks_dashboard",
		"snacks_picker_list",
		"snacks_picker_input",
		"snacks_layout_box",
		"noice",
		"notify",
		"NvimTree",
		"neo-tree",
		"TelescopePrompt",
		"lazy",
		"mason",
		"outline",
		"oil",
	},
	ignore_buftypes = {
		"nofile",
		"terminal",
		"prompt",
		"quickfix",
	},

	-- Allowed Kinds (Giữ nguyên)
	allowed_kinds = {
		[5] = true,
		[6] = true,
		[9] = true,
		[11] = true,
		[23] = true,
		[10] = true,
		[22] = true,
		Class = true,
		Method = true,
		Constructor = true,
		Function = true,
		Interface = true,
		Struct = true,
		Enum = true,
	},

	icons = {
		File = { icon = "󰈙", hl = "Identifier" },
		Module = { icon = "", hl = "Include" },
		Namespace = { icon = "󰌗", hl = "Include" },
		Package = { icon = "", hl = "Include" },
		Class = { icon = "󰌗", hl = "Type" },
		Method = { icon = "󰊕", hl = "Function" },
		Property = { icon = "", hl = "Identifier" },
		Field = { icon = "", hl = "Identifier" },
		Constructor = { icon = "", hl = "Special" },
		Enum = { icon = "󰕘", hl = "Type" },
		Interface = { icon = "󰕘", hl = "Type" },
		Function = { icon = "󰊕", hl = "Function" },
		Variable = { icon = "󰆧", hl = "Constant" },
		Constant = { icon = "󰏿", hl = "Constant" },
		String = { icon = "󰀬", hl = "String" },
		Number = { icon = "󰎠", hl = "Number" },
		Boolean = { icon = "✜", hl = "Boolean" },
		Array = { icon = "󰅪", hl = "Constant" },
		Object = { icon = "󰅩", hl = "Type" },
		Key = { icon = "󰌋", hl = "Type" },
		Null = { icon = "󰟢", hl = "Type" },
		EnumMember = { icon = "", hl = "Field" },
		Struct = { icon = "󰌗", hl = "Type" },
		Event = { icon = "", hl = "Type" },
		Operator = { icon = "󰆕", hl = "Operator" },
		TypeParameter = { icon = "󰊄", hl = "Identifier" },
	},
}

return M
