return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      -- Apply auto-tagging to these file types
      filetypes = {
        "html", -- HTML files
        "javascript", -- JavaScript files
        "javascriptreact", -- React JSX
        "typescript", -- TypeScript files
        "typescriptreact", -- React TSX
        "vue", -- Vue files
        "php", -- PHP files
        "blade", -- Laravel Blade templates
        "xml", -- XML files
        "markdown", -- Markdown files
        "svelte", -- Svelte files
      },
      -- Skip auto-renaming these tags
      skip_tags = {
        "area",
        "base",
        "br",
        "col",
        "command",
        "embed",
        "hr",
        "img",
        "slot",
        "input",
        "keygen",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr",
        "menuitem",
      },
    })
  end,
}
