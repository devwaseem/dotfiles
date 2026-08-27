return {
    'tzachar/highlight-undo.nvim',
    event = "VeryLazy",
    opts = {
        hlgroup = "HighlightUndo",
        duration = 300,
        pattern = { "*" },
        ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "alpha" },
    },
}
