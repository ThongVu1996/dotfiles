local blink = require("blink.cmp")

-- local get_intelephense_license = function()
-- 	local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt", "rb"))
-- 	local content = f:read("*a")
-- 	f:close()
-- 	return string.gsub(content, "%s+", "")
-- end

return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php", "blade" },
	root_markers = { "composer.json", ".git" },
	init_options = {
		-- licenceKey = get_intelephense_license(),
	},
	settings = {
		intelephense = {
			files = {
				exclude = {
					"**/.git/**",
					"**/.svn/**",
					"**/.hg/**",
					"**/CVS/**",
					"**/.DS_Store/**",
					"**/node_modules/**",
					"**/bower_components/**",
					"**/vendor/**/{Test,test,Tests,tests}/**",
					"**/.direnv/**", -- <== THIS FIXES YOUR ISSUE
				},
			},
		},
	},
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
