return {
    "ThongVu1996/simple-fold.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function(_, opts)
        require("simple_fold").setup(opts)
    end
    -- "test",
    -- event = { "BufReadPost", "BufNewFile" },
    -- dir = "/Users/thongvu/nix-config/nvim-plugin/simple-fold.nvim",
    -- opts = {},
    -- config = function(_, opts)
    --     print("Debug: chay moi")
    --     require("simple_fold").setup(opts)
    -- end
}