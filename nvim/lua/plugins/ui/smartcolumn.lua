local palette = require("core.palette")

local function get_highlight_color()
    local highlight_name = "VirtColumn"
    vim.api.nvim_set_hl(0, highlight_name, { fg = palette.overlay0 })
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
