return {
    "ThongVu1996/simple-noice.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
        require("simple-noice").setup(opts)
    end
}
