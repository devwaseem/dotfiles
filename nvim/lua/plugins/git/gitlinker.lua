return {
    'linrongbin16/gitlinker.nvim',
    cmd = {
        "GitLink",
    },
    config = function()
        require('gitlinker').setup({
            mappings = "<leader>gy"
        })
        vim.api.nvim_set_keymap('n', '<leader>gB',
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            { silent = true })
        vim.api.nvim_set_keymap('v', '<leader>gB',
            '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            {})
    end,
}
