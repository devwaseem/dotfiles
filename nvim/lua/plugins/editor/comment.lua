return {
    'numToStr/Comment.nvim',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring'
    },
    opts = {
        -- add any options here
    },
    lazy = false,
    keys = {
        { "<leader>/", "<cmd>execute 'normal gcc'<CR>", mode = "v" },
        { "<leader>/", "<cmd>execute 'normal gcc'<CR>", mode = "n" }
    }
}
