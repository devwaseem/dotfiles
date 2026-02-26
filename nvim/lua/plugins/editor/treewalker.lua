return {
    'aaronik/treewalker.nvim',

    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
        -- Whether to briefly highlight the node after jumping to it
        highlight = true,

        -- How long should above highlight last (in ms)
        highlight_duration = 250,

        -- The color of the above highlight. Must be a valid vim highlight group.
        -- (see :h highlight-group for options)
        highlight_group = 'CursorLine',
    },
    keys = {
        {
            "<C-k>",
            '<cmd>Treewalker Up<cr>',
            mode = { "n", "v" },
        },
        {
            "<C-j>",
            '<cmd>Treewalker Down<cr>',
            mode = { "n", "v" },
        },
        {
            "<C-h>",
            '<cmd>Treewalker Left<cr>',
            mode = { "n", "v" },
        },
        {
            "<C-l>",
            '<cmd>Treewalker Right<cr>',
            mode = { "n", "v" },
        },
        -- Swapping
        { "<C-m>k", "<cmd>Treewalker SwapUp<cr>",    mode = "n" },
        { "<C-m>j", "<cmd>Treewalker SwapDown<cr>",  mode = "n" },
        { "<C-m>h", "<cmd>Treewalker SwapLeft<cr>",  mode = "n" },
        { "<C-m>l", "<cmd>Treewalker SwapRight<cr>", mode = "n" },
    }
}
