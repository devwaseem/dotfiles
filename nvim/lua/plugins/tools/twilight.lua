return {
    "folke/twilight.nvim",
    keys = {
        { "<leader>zt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" }
    },
    opts = {
        context = 3,
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "function",
            "method",
            "table",
            "if_statement",
            "for_statement",
        },
    }

}
