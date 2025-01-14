return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"Saghen/blink.cmp",
		-- Auto update reference when change name file, name variable
		-- { "antosha417/nvim-lsp-file-operations", config = true },
		-- Enhance LSP for lua
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")

		local log = require("plenary.log").new({
			plugin = "lsp_debug",
			level = "debug",
			use_console = false,
		})

		local function filter(arr, fn)
			if type(arr) ~= "table" then
				vim.notify("Input is not a table!", vim.log.levels.WARN)
				return arr
			end

			local filtered = {}
			for k, v in pairs(arr) do
				if fn(v, k, arr) then
					table.insert(filtered, v)
				end
			end
			-- In danh sách sau khi lọc
			-- vim.notify("Filtered results: " .. vim.inspect(filtered), vim.log.levels.INFO)

			return filtered
		end

		local function filterReactDTS(value)
			-- vim.notify("Inspecting value: " .. vim.inspect(value), vim.log.levels.DEBUG)

			local uri = value.uri or value.targetUri
			if not uri then
				vim.notify("Value does not have a valid URI!", vim.log.levels.WARN)
				return false
			end

			return not string.match(uri, "%.d.ts")
		end

		-- Configure Blink CMP capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
		capabilities = vim.tbl_deep_extend("force", capabilities, {
			workspace = {
				didChangeWatchedFiles = {
					relativePatternSupport = true,
				},
			},
		})

		vim.lsp.code_actions = {
			previewer = "codeaction_native", -- Sử dụng previewer native với delta
		}

		-- Example using opts for defining servers
		local servers = {
			phpactor = {
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("composer.json", ".git") or vim.loop.cwd(),
				handlers = {
					["textDocument/publishDiagnostics"] = function() end,
				},
			},
			intelephense = {
				capabilities = capabilities,
				settings = {
					intelephense = {
						files = { maxSize = 5000000 },
						diagnostics = {
							enable = true,
						},
					},
				},
				root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
				flags = {
					debounce_text_changes = 150,
				},
			},
			ts_ls = {
				capabilities = capabilities,
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false -- Prettier formatting
				end,
				handlers = {
					["textDocument/definition"] = function(err, result, method, ...)
						-- In kết quả ban đầu
						-- vim.notify("Original results: " .. vim.inspect(result), vim.log.levels.INFO)

						if vim.islist(result) and #result > 1 then
							local filtered_result = filter(result, filterReactDTS)

							-- In kết quả sau khi lọc
							-- vim.notify("Filtered results: " .. vim.inspect(filtered_result), vim.log.levels.INFO)

							return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
						end

						vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
					end,
				},
			},
			volar = {
				capabilities = capabilities,
				filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
			},
			emmet_ls = {
				capabilities = capabilities,
				filetypes = { "html", "css", "scss", "typescriptreact", "javascriptreact", "vue", "jsx" },
			},
			lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				filetypes = { "lua" },
				typos_lsp = {
					cmd = { "typos-lsp" }, -- Đảm bảo rằng `typos-lsp` đã được cài đặt và có trong PATH
					filetypes = {
						"markdown", -- Markdown
						"text", -- Plain text
						"gitcommit", -- Git commit messages
						"php", -- PHP files
						"javascript", -- JavaScript
						"typescript", -- TypeScript
						"javascriptreact", -- JSX
						"typescriptreact", -- TSX
						"vue", -- Vue.js
						"html", -- HTML
						"css", -- CSS
					},
					root_dir = lspconfig.util.root_pattern(".git", vim.loop.cwd()),
				},
			},
		}

		-- Setup LSP servers using the updated capabilities from Blink CMP
		for server, config in pairs(servers) do
			lspconfig[server].setup(config)
		end

		-- Force type for php
		-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		-- 	pattern = "*.php",
		-- 	command = "LspStart phpactor",
		-- })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local keymap = vim.keymap.set
				local opts = { buffer = ev.buf, silent = true }

				-- Tìm tham chiếu
				opts.desc = "Find references"
				keymap("n", "gR", vim.lsp.buf.references, opts)

				-- Đi tới khai báo
				opts.desc = "Go to declaration"
				keymap("n", "gD", vim.lsp.buf.declaration, opts)

				-- Đi tới định nghĩa
				opts.desc = "Find definitions"
				keymap("n", "gd", vim.lsp.buf.definition, opts)

				-- Tìm các implementation
				opts.desc = "Find implementations"
				keymap("n", "gi", vim.lsp.buf.implementation, opts)

				-- Tìm type definitions
				opts.desc = "Find type definitions"
				keymap("n", "gt", vim.lsp.buf.type_definition, opts)

				-- Thao tác code
				opts.desc = "Code actions"
				keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				-- Đổi tên symbol
				opts.desc = "Rename symbol"
				keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Close quick-list fix"
				keymap("n", "<leader>q", "<cmd>cclose<CR>", opts)

				-- Tài liệu hover
				opts.desc = "Hover documentation"
				keymap("n", "K", vim.lsp.buf.hover, opts)

				-- Restart LSP
				opts.desc = "Restart LSP"
				keymap("n", "<leader>rs", ":LspRestart<CR>", opts)

				-- Format tài liệu
				opts.desc = "Format document"
				keymap("n", "<leader>fd", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
	end,
}
