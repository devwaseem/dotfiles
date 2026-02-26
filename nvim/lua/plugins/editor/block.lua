return {
    "HampusHauffman/block.nvim",
    cmd = "Block",
    keys = {
        { "<leader>ub", "<cmd>Block<cr>", desc = "Indent Block", },
    },
    config = function()
        require("block").setup()
    end
}
