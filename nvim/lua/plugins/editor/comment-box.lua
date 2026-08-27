return {
    "LudoPinelli/comment-box.nvim",
    keys = {
        { '<leader>vb', "<Cmd>CBccbox<CR>", desc = "Comment Box: Box Title" },
        { '<leader>vt', "<Cmd>CBllline<CR>", desc = "Comment Box: Titled Line" },
        { '<leader>vl', "<Cmd>CBline<CR>", desc = "Comment Box: Simple Line" },
        { '<leader>vm', "<Cmd>CBllbox14<CR>", desc = "Comment Box: Marked" },
        { '<leader>vd', "<Cmd>CBd<CR>", desc = "Comment Box: Remove a box" },
    },
    config = function()
        require("comment-box").setup()
    end,
}
