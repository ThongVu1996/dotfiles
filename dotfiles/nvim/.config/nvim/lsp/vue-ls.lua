local blink = require("blink.cmp")

-- Helper để tìm TypeScript/Vue plugin cho vtsls
local function get_vue_plugin_path()
	local local_plugin = vim.fn.getcwd() .. "/node_modules/@vue/typescript-plugin"
	if vim.fn.isdirectory(local_plugin) == 1 then
		return local_plugin
	end
	return nil
end

return {
	-- 1. Lệnh chạy server (Volar 2.0+)
	cmd = { "vue-language-server", "--stdio" },

	-- 2. Hỗ trợ file Vue
	filetypes = { "vue" },

	-- 3. Kích hoạt Hybrid Mode (Siêu nhẹ, siêu ổn định)
	init_options = {
		vue = {
			hybridMode = true, -- <== PHẢI LÀ TRUE CHO VTSLS
		},
	},

	-- Export helper cho vtsls
	get_vue_plugin_path = get_vue_plugin_path,

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
