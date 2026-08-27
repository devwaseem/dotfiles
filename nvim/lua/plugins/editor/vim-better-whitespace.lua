local palette = require("core.palette")

return {
    'ntpeters/vim-better-whitespace',
    event = "BufReadPost",
    config = function()
        vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = palette.red })

        vim.keymap.set('n', '<leader>uw', '<cmd>ToggleWhitespace<cr>')

        vim.g.strip_whitespace_on_save = true
        vim.g.better_whitespace_filetypes_blacklist = {
            "dbout"
        }
    end

}
