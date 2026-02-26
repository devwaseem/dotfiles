return {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
        { "<leader>lso", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    config = function()
        require("outline").setup {}
    end,
}
