return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        local parsers = require("nvim-treesitter.parsers")
        parsers.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade",
        }

        local ts = require("nvim-treesitter")

        local ctx_ok, ts_context = pcall(require, "treesitter-context")
        if ctx_ok then
            ts_context.setup({
                enable = true,            -- Enable this plugin
                max_lines = 4,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded
                mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                separator = nil,          -- Separator between context and content
                zindex = 20,              -- The Z-index of the context window
            })

            -- (Optional) Keymap to jump to the pinned context line
            vim.keymap.set("n", "[c", function()
                ts_context.go_to_context(vim.v.count1)
            end, { silent = true, desc = "Go to Context" })
        end

        -- --- 2. CORE TREESITTER CONFIG ---
        -- New setup style (Rewrite)
        ts.setup({
            -- Leave as default or set a custom installation directory
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Install parsers (Using the correct new API)
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
            "blade",
        })

        -- Enable Highlight (Built-in for Neovim 0.12+)
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}