return {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    dependencies = { "telescope.nvim" },
    config = function()
        require("telescope").load_extension("ui-select")
    end,
}
