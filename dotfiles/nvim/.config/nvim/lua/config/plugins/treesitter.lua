return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup({
			-- Modules (required field, leave empty if not overriding)
			modules = {},

			-- Synchronize parser installation (false = async)
			sync_install = false,

			-- Ignore installing these parsers
			ignore_install = { "haskell" }, -- Example: ignore Haskell parser

			-- Enable syntax highlighting
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			-- Enable indentation
			indent = {
				enable = true,
			},

			-- Ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vue",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"php",
				"blade",
				"php_only",
				"phpdoc",
				"xml",
			},

			-- Automatically install missing parsers
			auto_install = true,

			-- Incremental selection configuration
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})

		-- Configure folding with Tree-sitter
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldenable = false -- Disable folding by default
		require("nvim-ts-autotag").setup()

		local parsers = require("nvim-treesitter.parsers")
		local parser_config = nil
		if pcall(require, "nvim-treesitter.parsers") then
			if parsers.get_parser_configs then
				parser_config = parsers.get_parser_configs()
			else
				parser_config = parsers.list
			end
		end

		if parser_config then
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}
		end

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
}
