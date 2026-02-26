return {
    'lafarr/hierarchy.nvim',
    event = "LspAttach",
    keys = {
        { "<leader>lh", "<cmd>FunctionReferences<cr>", desc = "Calls hierarchy" },
    },
    config = function()
        require('hierarchy').setup({
            depth = 5
        })
    end
}
