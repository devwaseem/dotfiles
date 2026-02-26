return {
    "LudoPinelli/comment-box.nvim",
    config = function()
        require("comment-box").setup()
        vim.keymap.set('n', '<leader>vb', "<Cmd>CBccbox<CR>", { desc = "Comment Box: Box Title" })
        vim.keymap.set('n', '<leader>vt', "<Cmd>CBllline<CR>", { desc = "Comment Box: Titled Line" })
        vim.keymap.set('n', '<leader>vl', "<Cmd>CBline<CR>", { desc = "Comment Box: Simple Line" })
        vim.keymap.set('n', '<leader>vm', "<Cmd>CBllbox14<CR>", { desc = "Comment Box: Marked" })
        vim.keymap.set('n', '<leader>vd', "<Cmd>CBd<CR>", { desc = "Comment Box: Remove a box" })
    end,
}
