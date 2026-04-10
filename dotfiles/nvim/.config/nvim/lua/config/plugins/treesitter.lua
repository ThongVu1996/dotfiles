return {
	"nvim-treesitter/nvim-treesitter",
	-- Không set branch để nó lấy bản mặc định (Rewrite/Main)
	lazy = false,
	build = ":TSUpdate",
	config = function()

		local ts = require("nvim-treesitter")

		-- Cấu hình kiểu mới (Rewrite)
		ts.setup({
			-- Để mặc định hoặc set thư mục cài đặt
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Cài đặt parser (Theo đúng API mới)
		ts.install({
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
			"xml",
			"nix",
		})

		-- Bật Highlight (Built-in Neovim 0.12)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- Đăng ký Blade Parser (Template cho Rewrite)
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				local p_ok, parsers = pcall(require, "nvim-treesitter.parsers")
				if p_ok and parsers then
					parsers.blade = {
						install_info = {
							url = "https://github.com/EmranMR/tree-sitter-blade",
							files = { "src/parser.c" },
							branch = "main",
						},
						filetype = "blade",
					}
				end
			end,
		})

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
}
