return {
    "danymat/neogen",
    version = "*",
    keys = {
        { "<leader>lc", function() require('neogen').generate() end, mode = "n" },
    },
    config = function()
        require("neogen").setup({
            snippet_engine = "luasnip",
            input_after_comment = true,
        })
    end
}
