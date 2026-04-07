local blink = require("blink.cmp")

-- Helper nội bộ (Để tránh dùng require chéo gây lỗi module not found)
local function get_vue_plugin_path()
	local local_plugin = vim.fn.getcwd() .. "/node_modules/@vue/typescript-plugin"
	if vim.fn.isdirectory(local_plugin) == 1 then
		return local_plugin
	end
	return nil
end

return {
	-- 1. Lệnh chạy server (Bản nâng cấp mạnh mẽ nhất cho TS/React)
	cmd = { "vtsls", "--stdio" },

	-- 2. Hỗ trợ React và TypeScript thuần
	filetypes = {
		"javascript", "javascriptreact", "javascript.jsx",
		"typescript", "typescriptreact", "typescript.tsx"
	},

	-- 3. Cấu hình lai cho Vue (Hybrid Mode)
	settings = {
		vtsls = {
			-- Cho phép vtsls hiểu file .vue để check types cho Volar
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = get_vue_plugin_path() or "",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
		-- Tự động import cực nhanh giống VS Code
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
