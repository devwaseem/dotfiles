return {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "telescope.nvim" },
    config = function()
        require("telescope").load_extension("ui-select")
    end,
}
