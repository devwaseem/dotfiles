return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = "<space>",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add {
            { "<leader>f", group = "Find", icon = "" },
            { "<leader>l", group = "LSP", icon = "" },
            { "<leader>u", group = "UI", icon = "" },
            { "<leader>g", group = "Git", icon = "" },
            { "<leader>e", group = "Explorer", icon = "" },
            { "<leader>h", group = "Hover Split", icon = "󰞋" },
            { "<leader>t", group = "Terminal", icon = "" },
            { "<leader>s", group = "Scratch Pad", icon = "" },
            { "<leader>r", group = "Run Tests", icon = "" },
        }
        wk.add({
            {
                "<leader>b",
                group = "buffers",
                expand = function()
                    return require("which-key.extras").expand.buf()
                end
            },
        })
        -- vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
        -- vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
    end,
}
