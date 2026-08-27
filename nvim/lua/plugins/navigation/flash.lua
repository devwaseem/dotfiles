local palette = require("core.palette")

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
        local plugin_hls = {
            FlashBackdrop = { fg = palette.overlay0 },
            FlashMatch = { bg = palette.surface1, fg = palette.text },
            FlashLabel = { fg = palette.yellow, bold = true },
            FlashCurrent = { fg = palette.peach },
        }

        for hl, colors in pairs(plugin_hls) do
            vim.api.nvim_set_hl(0, hl, colors)
        end
    end,
}
