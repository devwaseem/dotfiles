return {
    'brenoprata10/nvim-highlight-colors',
    ft = { "astro", "css", "html", "javascript", "javascriptreact", "sass", "scss", "typescript", "typescriptreact", "vue" },
    config = function()
        require('nvim-highlight-colors').setup({})
    end
}
