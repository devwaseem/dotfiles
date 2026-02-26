local function get_material_highlights()
    local colors = require('material.colors')
    local fg = colors.main.gray
    local bg = colors.editor.bg
    local active_fg = colors.editor.fg
    local active_bg = colors.editor.bg

    local highlights = {

        fill = {},
        background = {},
        tab = {},
        tab_selected = {},
        tab_separator = {},
        tab_separator_selected = { fg = active_bg },
        tab_close = {},
        close_button = {},
        close_button_visible = {},
        close_button_selected = {},
        buffer_visible = {},
        buffer_selected = {},
        numbers = {},
        numbers_visible = {},
        numbers_selected = {},
        diagnostic = {},
        diagnostic_visible = {},
        diagnostic_selected = {},
        hint = {},
        hint_visible = {},
        hint_selected = {},
        hint_diagnostic = {},
        hint_diagnostic_visible = {},
        hint_diagnostic_selected = {},
        info = {},
        info_visible = {},
        info_selected = {},
        info_diagnostic = {},
        info_diagnostic_visible = {},
        info_diagnostic_selected = {},
        warning = {},
        warning_visible = {},
        warning_selected = {},
        warning_diagnostic = {},
        warning_diagnostic_visible = {},
        warning_diagnostic_selected = {},
        error = {},
        error_visible = {},
        error_selected = {},
        error_diagnostic = {},
        error_diagnostic_visible = {},
        error_diagnostic_selected = {},
        modified = {},
        modified_visible = {},
        modified_selected = {},
        duplicate_selected = {},
        duplicate_visible = {},
        duplicate = {},
        separator_selected = {},
        separator_visible = {},
        separator = { fg = bg },
        indicator_visible = { fg = fg, },
        indicator_selected = { fg = active_bg },
        pick_selected = {},
        pick_visible = {},
        pick = {},
        offset_separator = {},
        trunc_marker = {}
    }

    local new_highlights = {}

    for key, value in pairs(highlights) do
        local options = {}
        if key:match('selected') then
            options = {
                bg = active_bg,
                bold = true,
                italic = true,
            }
        else
            options = {
                fg = colors.editor.line_numbers,
                bg = colors.editor.bg,
                italic = false,
                bold = false,
            }
        end
        new_highlights[key] = vim.tbl_deep_extend("force", options, value)
    end

    return new_highlights
end

return {
    'akinsho/bufferline.nvim',
    enabled = false,
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local exclude_buffers = { '' }
        local bufferline = require('bufferline')


        bufferline.setup({
            highlights = get_material_highlights(),
            options = {
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                indicator = {
                    style = 'none'
                },

                custom_filter = function(buf_number, buf_numbers)
                    for _, bufname in pairs(exclude_buffers) do
                        if vim.fn.bufname(buf_number) == bufname then
                            return false
                        end
                    end
                    return true
                end,
                offsets = {
                    { filetype = "NeoTree", text = "File Explorer" }
                },
                show_buffer_icons = false,
                seperator_style = "thin"
            }
        })
    end
}
