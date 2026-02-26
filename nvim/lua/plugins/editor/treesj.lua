return {
    'Wansmer/treesj',
    enabled = true,
    keys = {
        {
            "J",
            function()
                local ok = pcall(require('treesj').toggle)
                if not ok then
                    vim.cmd('normal! J')
                end
            end,
            desc = "Join Toggle"
        },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('treesj').setup({
            use_default_keymaps = false,
        })
    end,
}
