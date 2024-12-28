return {
  "saghen/blink.cmp",
  event = { "LspAttach" },
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  opts = {
    keymap = {
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = { enabled = true },
  },
}
