return {
    "pogyomo/winresize.nvim",
    keys = {
        { "rh", function() require("winresize").resize(0, 2, "left") end, desc = "Resize window left" },
        { "rj", function() require("winresize").resize(0, 1, "down") end, desc = "Resize window down" },
        { "rk", function() require("winresize").resize(0, 1, "up") end, desc = "Resize window up" },
        { "rl", function() require("winresize").resize(0, 2, "right") end, desc = "Resize window right" },
    },
}
