return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			preset = {
				header = [[
  /$$$$$$  /$$$$$$$$ /$$   /$$  /$$$$$$ 
 /$$__  $$| $$_____/| $$  /$$/ /$$__  $$
| $$  \ $$| $$      | $$ /$$/ | $$  \__/
| $$$$$$$$| $$$$$   | $$$$$/  | $$      
| $$__  $$| $$__/   | $$  $$  | $$      
| $$  | $$| $$      | $$\  $$ | $$    $$
| $$  | $$| $$$$$$$$| $$ \  $$|  $$$$$$/
|__/  |__/|________/|__/  \__/ \______/ 
        ]],
			},
			enable = true,
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,
			},
			sections = {
				{ section = "header", indent = 60 },
				{
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
				{
					pane = 2,
					section = "terminal",
					cmd = "",
					height = 5,
					padding = 6,
					indent = 10,
				},
				{
					pane = 2,
					{
						icon = " ",
						title = "Recent Files",
						padding = 1,
					},
					{
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{
						icon = " ",
						title = "Projects",
						padding = 1,
					},
					{
						section = "projects",
						indent = 2,
						padding = 1,
					},
				},
			},
		},
		indent = { enabled = true },
		input = { enabled = true },
		rename = { enabled = true },
		notifier = {
			enabled = true,
			style = "fancy",
			vim.api.nvim_create_autocmd("LspProgress", {
				---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
				callback = function(ev)
					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(vim.lsp.status(), "info", {
						id = "lsp_progress",
						title = "LSP Progress",
						opts = function(notif)
							notif.icon = ev.data.params.value.kind == "end" and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			}),
		},
		notify = { enabled = true },
		dim = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},

	keys = {
		{
			"<leader>nn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
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
	},
}
