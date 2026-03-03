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
        -- Swapping
        { "<leader>sk", "<cmd>Treewalker SwapUp<cr>",    mode = "n" },
        { "<leader>sj", "<cmd>Treewalker SwapDown<cr>",  mode = "n" },
        { "<leader>sh", "<cmd>Treewalker SwapLeft<cr>",  mode = "n" },
        { "<leader>sl", "<cmd>Treewalker SwapRight<cr>", mode = "n" },
    }
}
