return {
    "supermaven-inc/supermaven-nvim",
    -- cmd = { "SupermavenStart", "SupermavenToggle" },
    -- keys = {
    --     { "<leader>us", "<cmd>SupermavenToggle<cr>" },
    -- },
    config = function()
        require("supermaven-nvim").setup({})
    end,
}
