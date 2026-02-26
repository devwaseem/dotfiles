return {
    'ntpeters/vim-better-whitespace',
    event = "BufReadPost",
    config = function()
        if vim.g.colors_name == "material" and pcall(require, 'material') then
            vim.cmd("highlight ExtraWhitespace guibg=" .. require('material.colors').main.red)
        end

        vim.keymap.set('n', '<leader>uw', '<cmd>ToggleWhitespace<cr>')

        vim.g.strip_whitespace_on_save = true
        vim.g.better_whitespace_filetypes_blacklist = {
            "dbout"
        }
    end

}
