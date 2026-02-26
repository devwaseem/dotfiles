return {
    "Jxstxs/conceal.nvim",
    keys = {
        { "<leader>uc", desc = "Toggle Conceal" },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },

    config = function()
        local conceal = require("conceal")

        -- should be run before .generate_conceals to use user Configuration
        conceal.setup({
            --[[ ["language"] = {
        enabled = bool,
        ["keyword"] = {
            enabled     = bool,
            conceal     = string,
            highlight   = string
        }
    } ]]
            ["lua"] = {
                ["local"] = {
                    enabled = true -- to disable concealing for "local"
                },
                ["return"] = {
                    conceal = "R" -- to set the concealing to "R"
                },
                ["for"] = {
                    highlight = "keyword" -- to set the Highlight group to "@keyword"
                }
            },
            ["python"] = {
                enabled = true
            }
            -- ["language"] = {
            --     enabled = false -- to disable the whole language
            -- }
        })

        -- generate the scm queries
        -- only need to be run when the Configuration changes
        conceal.generate_conceals()

        vim.keymap.set("n", "<leader>tc", function()
            require("conceal").toggle_conceal(1)
        end, { desc = "Toggle Conceal" })
    end

}
