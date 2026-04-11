local blink = require("blink.cmp")

-- Helper to find TypeScript/Vue plugin for vtsls
local function get_vue_plugin_path()
	local local_plugin = vim.fn.getcwd() .. "/node_modules/@vue/typescript-plugin"
	if vim.fn.isdirectory(local_plugin) == 1 then
		return local_plugin
	end
	return nil
end

return {
	-- 1. Server execution command (Volar 2.0+)
	cmd = { "vue-language-server", "--stdio" },

	-- 2. Supported filetypes
	filetypes = { "vue" },

	-- 3. Hybrid Mode activation (Lightweight and stable)
	init_options = {
		vue = {
			hybridMode = true, -- <== MUST BE TRUE FOR VTSLS COMPATIBILITY
		},
	},

	-- Export helper for vtsls integration
	get_vue_plugin_path = get_vue_plugin_path,

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
