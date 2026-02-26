return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    enabled = true,
    keys = {
        {
            '<Leader>ui',
            '<cmd>IBLToggle<cr>',
            desc = 'Indent lines toggle',
        },
    },
    opts = {
        indent = {
            -- char = "│",
            char = " ",
            -- tab_char = "│",
            tab_char = " ",
        },
        scope = { enabled = true },
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Starter",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
            },
        },
    },
    main = "ibl",
}
