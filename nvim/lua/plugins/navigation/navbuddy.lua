return {
    "SmiteshP/nvim-navbuddy",
    enabled = true,
    dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim",        -- Optional
        "nvim-telescope/telescope.nvim" -- Optional
    },
    keys = {
        { "<leader>;", "<cmd>Navbuddy<cr>", desc = "Toggle Navigation Buddy" },
    },
}
