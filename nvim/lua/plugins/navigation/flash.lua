return {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
    },
    -- stylua: ignore
    keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function()
        if vim.g.colors_name == "material" and pcall(require, 'material') then
            local colors = require "material.colors"
            local e = colors.editor

            local plugin_hls = {
                FlashBackdrop = { fg = e.disabled },
                FlashMatch = { bg = e.selection, fg = e.fg },
                FlashLabel = { fg = e.accent, bg = nil, bold = true },
                FlashCurrent = { fg = e.title }
            }

            for hl, col in pairs(plugin_hls) do
                vim.api.nvim_set_hl(0, hl, col)
            end
        end
    end,
}
