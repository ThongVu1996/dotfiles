return {
    "ThongVu1996/simple-fold.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- Đã sửa thành git-plugin-nvim để loading được
    -- dir = "/Users/thongvu/nix-config/git-plugin-nvim/simple-fold.nvim",
    opts = {},
    config = function(_, opts)
        require("simple-fold").setup(opts)
    end
}