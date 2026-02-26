return {
    "andrewradev/switch.vim",
    event = "VeryLazy",
    keys = {
        { "-", "<CMD>Switch<CR>", desc = "Switch text segments" },
    },
    config = function()
        vim.g.switch_mapping = "-"
    end
}
