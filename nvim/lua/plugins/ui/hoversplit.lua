return {
    "roobert/hoversplit.nvim",
    keys = {
        { "<leader>ks", desc = "Split remain focused" },
        { "<leader>kv", desc = "Vertical split remain focused" },
        { "<leader>kS", desc = "Split" },
        { "<leader>kV", desc = "Vertical split" },
    },
    config = function()
        require("hoversplit").setup({
            key_bindings = {
                split_remain_focused = "<leader>ks",
                vsplit_remain_focused = "<leader>kv",
                split = "<leader>kS",
                vsplit = "<leader>kV",
            },
        })
    end,
}
