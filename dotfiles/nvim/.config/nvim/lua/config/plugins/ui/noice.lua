return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    cmdline = {
      enabled = true, -- Enable cmdline
      view = "cmdline_popup", -- Display cmdline in the center of the screen
      format = {
        cmdline = { pattern = "^:", icon = " ", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "40%", -- Display slightly above center vertically
          col = "50%", -- Centered horizontally
        },
        size = {
          width = 60, -- Cmdline width
          height = "auto", -- Auto height
        },
        border = {
          style = "rounded", -- Rounded corners
          padding = { 0, 1 }, -- Padding between content and border
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winblend = 10, -- Subtle transparency
        },
      },
    },
    presets = {
      bottom_search = false, -- Disable search bar at the bottom
      command_palette = true, -- Show cmdline in the center (Command Palette style)
      long_message_to_split = true, -- Move long messages to a split window
      lsp_doc_border = true, -- Add borders to hover docs and signature help
    },
  },
}
