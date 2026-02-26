return {
    "letieu/jot.lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>j",
            function()
                require('jot').toggle({
                    relative = "editor",
                    border = "none",
                    width = 100,
                    height = 30,
                    row = 5,
                    col = 35,
                })
            end,
            desc = "Jot: Open jot"
        }
    }
}
