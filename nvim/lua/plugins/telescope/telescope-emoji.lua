return {
    "xiyaowong/telescope-emoji.nvim",
    keys = {
        {"<leader>fe", "<cmd>Telescope emoji<cr>", desc="Find Emoji" }
    },
    config = function()
        require("telescope").load_extension("emoji")
    end

}
