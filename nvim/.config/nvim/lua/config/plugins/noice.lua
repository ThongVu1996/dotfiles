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
      enabled = true, -- Bật cmdline
      view = "cmdline_popup", -- Hiển thị cmdline ở giữa màn hình
      format = {
        cmdline = { pattern = "^:", icon = " ", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%", -- Hiển thị ở giữa màn hình theo chiều dọc
          col = "50%", -- Hiển thị ở giữa màn hình theo chiều ngang
        },
        size = {
          width = 60, -- Chiều rộng cmdline
          height = 1, -- Chiều cao tự động
        },
        border = {
          style = "rounded", -- Viền bo tròn
          padding = { 0, 1 }, -- Khoảng cách giữa nội dung và viền
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
          height = 1,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winblend = 50, -- Tạo hiệu ứng mờ
        },
      },
    },
    presets = {
      bottom_search = false, -- Tắt thanh tìm kiếm ở dưới màn hình
      command_palette = true, -- Hiển thị cmdline ở giữa màn hình
      long_message_to_split = true, -- Chuyển thông báo dài vào split
      lsp_doc_border = true, -- Thêm viền cho hover docs và signature help
    },
  },
}
