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
	-- 1. Server execution command (The most powerful choice for TS/React)
	cmd = { "vtsls", "--stdio" },

	-- 2. Support for React and pure TypeScript
	filetypes = {
		"javascript", "javascriptreact", "javascript.jsx",
		"typescript", "typescriptreact", "typescript.tsx"
	},

	-- 3. Hybrid configuration for Vue support
	settings = {
		vtsls = {
			-- Allow vtsls to understand .vue files for type checking with Volar
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
		-- High-speed auto-imports similar to VS Code
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
