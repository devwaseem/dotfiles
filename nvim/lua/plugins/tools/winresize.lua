return {
    "pogyomo/winresize.nvim",
    config = function()
        local resize = function(win, amt, dir)
            return function()
                require("winresize").resize(win, amt, dir)
            end
        end
        vim.keymap.set("n", "rh", resize(0, 2, "left"))
        vim.keymap.set("n", "rj", resize(0, 1, "down"))
        vim.keymap.set("n", "rk", resize(0, 1, "up"))
        vim.keymap.set("n", "rl", resize(0, 2, "right"))
    end,
}
