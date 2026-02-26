return {
    "xzbdmw/clasp.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("clasp").setup({
            pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["$"] = "$" },
        })

        -- Jumping from smallest region to largest region
        vim.keymap.set({ "i" }, "<C-n>", function()
            require("clasp").wrap("next")
        end)

        -- Jumping from largest region to smallest region
        vim.keymap.set({ "i" }, "<C-p>", function()
            require("clasp").wrap("prev")
        end)
    end,
}
