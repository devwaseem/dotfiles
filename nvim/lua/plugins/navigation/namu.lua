return {
    "bassamsdata/namu.nvim",
    event = "VeryLazy",
    opts = {
        namu_symbols = { -- Specific Module options
            options = {
                display = { format = "tree_guides" }
            },
        },
    },
    keys = {
        {
            "<leader>ns",
            "<cmd>Namu symbols<cr>",
            desc = "Namu: Symbols",
        },
        {
            "<leader>nw",
            "<cmd>Namu workspace<cr>",
            desc = "Namu: Workspace",
        },
        {
            "<leader>nb",
            "<cmd>Namu watchtower<cr>",
            desc = "Namu: Watchtower",
        },
        {
            "<leader>nd",
            "<cmd>Namu diagnostics<cr>",
            desc = "Namu: Diagnostics",
        },
        {
            "<leader>nc",
            "<cmd>Namu call in<cr>",
            desc = "Namu: Call In",
        },
    },
}
