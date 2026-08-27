return {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
        require("hlslens").setup({
            calm_down = true,
            nearest_only = true,
            nearest_float_when = 'always'
        })
    end,
}
