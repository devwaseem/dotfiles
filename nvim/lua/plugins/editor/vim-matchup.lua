return {
    "andymass/vim-matchup",
    lazy = false,
    config = function()
        require("match-up").setup({
            treesitter = {
                stopline = 500,
            },
        })
    end
}
