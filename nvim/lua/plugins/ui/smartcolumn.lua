local function get_highlight_color()
    local highlight_name = "VirtColumn"
    local color = "grey"
    if vim.g.colors_name == "material" and pcall(require, 'material') then
        local colors = require('material.colors')
        color = colors.editor.line_numbers
    end
    vim.cmd("highlight " .. highlight_name .. " ctermbg=0 guifg=" .. color)
    return highlight_name
end

return {
    "m4xshen/smartcolumn.nvim",
    opts = {
        colorcolumn = "79",
        disabled_filetypes = {
            "NvimTree",
            "mason",
            "help",
            "checkhealth",
            "lspinfo",
            "noice",
            "Trouble",
            "alpha",
        },
    }
}
