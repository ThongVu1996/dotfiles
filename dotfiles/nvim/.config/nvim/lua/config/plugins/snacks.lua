return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		indent = { enabled = true },
		input = { enabled = false },
		rename = { enabled = true },
		notifier = {
			enabled = true,
			style = "fancy",
		},
		notify = { enabled = true },
		dim = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		explorer = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					layout = { layout = { position = "right" } },
				},
			},

			-- 2. Filename display formatting
			formatters = {
				file = {
					filename_first = true, -- Show filename first, then the path
				},
			},

			-- 3. Visibility configuration
			hidden = true, -- Show hidden files (.config, .env, etc.)
			ignored = false, -- Include files in .gitignore
			exclude = {
				"node_modules",
				".direnv",
				".git",
				"dist",
				"build",
				-- "vendor", -- Uncomment for PHP/Laravel projects
			},
			-- 1. DEFINE HANDLERS HERE (To ensure access to Picker variable)
			actions = {
				copy_to_clipboard = function(picker, item)
					-- Access the correct picker instance
					if not item then
						item = picker:current()
					end

					if item then
						-- Extract display text or file path
						local content = item.text or item.file or item.name or vim.inspect(item)

						-- Copy to system clipboard
						vim.fn.setreg("+", content)

						vim.notify("✅ Copied: " .. content, vim.log.levels.INFO)
					else
						vim.notify("⚠️ No item selected to copy", vim.log.levels.WARN)
					end
				end,
			},

			win = {
				input = {
					keys = {
						-- 2. CALL THE DEFINED ACTION
						["<c-y>"] = {
							"copy_to_clipboard",
							mode = { "n", "i" },
							desc = "Copy notification history to Clipboard",
						},
					},
				},
			},
		},
		lazygit = {
			enabled = true,
			configure = true,
			config = {
				-- Aplly for Nushell
				os = {
					editPreset = "",
					edit = [[nu -c 'nvim --server $env.NVIM --remote-send "<C-\\\><C-n>:e {{filename}}<CR>:lua Snacks.lazygit()<CR>" out+err> /dev/null']],
					open = [[nu -c 'nvim --server $env.NVIM --remote-send "<C-\\\><C-n>:e {{filename}}<CR>:lua Snacks.lazygit()<CR>"']],
				},
			},
		},
		gitbrowse = {
			what = "branch",
		},
		styles = {
			-- INFO: show top right of screen
			snacks_image = {
				relative = "editor",
				col = -1,
			},
		},
		image = {
			enabled = true,
			force = true,
			wo = {
				winhighlight = "FloatBorder:WhichKeyBorder",
			},
			doc = {
				inline = false,
				max_width = 80,
				max_height = 40,
			},
		},
		win = {
			input = {
				keys = {
					-- 2. CALL THE DEFINED ACTION
					["<c-y>"] = {
						"copy_to_clipboard",
						mode = { "n", "i" },
						desc = "Copy notification history to Clipboard",
					},
				},
			},
		},
	},

	keys = {
		-- Top Pickers & Explorer
		{
			"<leader>hh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>uu",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},

		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>ee",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>nn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		-- Git
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>rf",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		-- Find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		-- find
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true, ignored = true })
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Find Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Find Recent",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep({ regex = false, args = { "-F" }, prompt = "🔍 Plain Text Search: " })
			end,
			desc = "Grep (Fixed-String Mode)",
		},
		-- Use regex
		{
			"<leader>sR",
			function()
				Snacks.picker.grep({ regex = true, prompt = "🔍 Regex Search: " })
			end,
			desc = "Grep (Regex Mode)",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions({
					finder = "lsp_definitions",
					format = "file",
					include_current = false,
					auto_confirm = true,
					jump = { tagstack = true, reuse_win = true },
					filter = {
						unique_by = { "filename", "lnum" }, -- remove duplicate result
						fn = function(item)
							return not string.match(item.filename or "", "node_modules")
						end,
					},
				})
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
				vim.cmd("normal! zz")
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
				vim.cmd("normal! zz")
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<leader>lr",
			function()
				Snacks.picker.lsp_references({ layout = { position = "center", width = 0.8, height = 0.6 } })
			end,
			desc = "LSP References in Floating Picker",
		},
		-- git browser

		-- Copy permalink of the current line or selected range to clipboard
		{
			"<leader>gp",
			function()
				local start_line, end_line = nil, nil

				-- Get the start and end line if in Visual mode
				if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
					start_line = vim.fn.line("'<") -- Start line of the selected range
					end_line = vim.fn.line("'>") -- End line of the selected range
				else
					start_line = vim.fn.line(".") -- If not in Visual mode, use the current line
					end_line = start_line
				end

				-- Call gitbrowse with line range information
				require("snacks").gitbrowse.open({
					what = "permalink",
					line_start = start_line,
					line_end = end_line,
					open = function(url)
						vim.fn.setreg("+", url) -- Copy URL to clipboard
						vim.notify("Permalink copied to clipboard: Lines " .. start_line .. "-" .. end_line)
					end,
				})
			end,
			desc = "Copy permalink of current line or selected range to clipboard",
			mode = { "n", "v" },
		},

		{
			"<leader>gF",
			function()
				require("snacks").gitbrowse({ what = "branch" })
			end,
			desc = "Open current file in browser",
		},
		{
			"<leader>gc",
			function()
				require("snacks").gitbrowse({ what = "commit" })
			end,
			desc = "Open current commit in browser",
		},
		{
			"<leader>gr",
			function()
				require("snacks").gitbrowse({ what = "repo" })
			end,
			desc = "Open entire repository in browser",
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		
		--  LSP Progress redirection to Snacks Notifier
		local progress = vim.defaulttable()
		vim.api.nvim_create_autocmd("LspProgress", {
			---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
				if not client or type(value) ~= "table" then
					return
				end
				local p = progress[client.id]

				for i = 1, #p + 1 do
					if i == #p + 1 or p[i].token == ev.data.params.token then
						p[i] = {
							token = ev.data.params.token,
							msg = ("[%3d%%] %s%s"):format(
								value.kind == "end" and 100 or value.percentage or 100,
								value.title or "",
								value.message and (" **%s**"):format(value.message) or ""
							),
							done = value.kind == "end",
						}
						break
					end
				end

				local msg = {} ---@type string[]
				progress[client.id] = vim.tbl_filter(function(v)
					return table.insert(msg, v.msg) or not v.done
				end, p)

				local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				vim.notify(table.concat(msg, "\n"), "info", {
					id = "lsp_progress",
					title = client.name,
					opts = function(notif)
						notif.icon = #progress[client.id] == 0 and " "
							or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
					end,
				})
			end,
		})
	end,
}
