return {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
        require("spider").setup({
            skipInsignificantPunctuation = true,
            consistentOperatorPending = true,
            subwordMovement = true,
        })

        vim.keymap.set("n", "w", "<cmd>lua require('spider').motion('w')<CR>")
        vim.keymap.set("n", "e", "<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set("n", "b", "<cmd>lua require('spider').motion('b')<CR>")

        vim.keymap.set("o", "w", "<cmd>lua require('spider').motion('w')<CR>")
        vim.keymap.set("o", "e", "<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set("o", "b", "<cmd>lua require('spider').motion('b')<CR>")

        vim.keymap.set("x", "w", "<cmd>lua require('spider').motion('w')<CR>")
        vim.keymap.set("x", "e", "<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set("x", "b", "<cmd>lua require('spider').motion('b')<CR>")

        vim.keymap.set("n", "cw", "ce", { remap = true })

        vim.keymap.set("i", "<C-f>", "<Esc>l<cmd>lua require('spider').motion('w')<CR>i")
        vim.keymap.set("i", "<C-b>", "<Esc><cmd>lua require('spider').motion('b')<CR>i")
    end

}
