-- animations = {
--     "matrix",
--     "rain",
--     "game_of_life",
--     "move_left",
--     "move_right",
--     "scramble",
--     "random_case",
--     "bounce",
--     "starfield",
--     "pipes",
--     "fire",
--     "snow",
--     "zoo",
--   },
--

return {
    "Root-lee/screensaver.nvim",
    keys = {
        { "<leader>Us", desc = "Screensaver" },
        {
            "<leader>Usm",
            function()
                require("screensaver").start('matrix')
            end,
            desc = "Screensaver - cmatrix"
        },
        {
            "<leader>Usr",
            function()
                require("screensaver").start('rain')
            end,
            desc = "Screensaver - rain"
        },
        {
            "<leader>Usg",
            function()
                require("screensaver").start('game_of_life')
            end,
            desc = "Screensaver - game of life"
        },
        {
            "<leader>Uss",
            function()
                require("screensaver").start('scramble')
            end,
            desc = "Screensaver - scramble"
        },
        {
            "<leader>Usc",
            function()
                require("screensaver").start('random_case')
            end,
            desc = "Screensaver - random case"
        },
        {
            "<leader>Usb",
            function()
                require("screensaver").start('bounce')
            end,
            desc = "Screensaver - bounce"
        },
        {
            "<leader>Uss",
            function()
                require("screensaver").start('starfield')
            end,
            desc = "Screensaver - starfield"
        },
        {
            "<leader>Usp",
            function()
                require("screensaver").start('pipes')
            end,
            desc = "Screensaver - pipes"
        },
        {
            "<leader>Usf",
            function()
                require("screensaver").start('fire')
            end,
            desc = "Screensaver - fire"
        },
        {
            "<leader>Usn",
            function()
                require("screensaver").start('snow')
            end,
            desc = "Screensaver - snow"
        },
        {
            "<leader>Usz",
            function()
                require("screensaver").start('zoo')
            end,
            desc = "Screensaver - zoo"
        },
    },
    config = function()
        require("screensaver").setup({
            auto_start = false,
            winblend = 0,
        })
    end,
}
