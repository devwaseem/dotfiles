return {
    'echasnovski/mini.starter',
    -- enabled = true,
    enabled = false,
    version = '*',
    event = "VimEnter",
    config = function()
        -- if vim.g.colors_name == "material" and pcall(require, 'material') then
        --     local colors = require('material.colors')
        --     vim.api.nvim_set_hl(0, 'MiniStarterFooter', { fg = colors.editor.line_numbers })
        --     vim.api.nvim_set_hl(0, 'MiniStarterHeader', { fg = colors.editor.accent })
        --     vim.api.nvim_set_hl(0, 'MiniStarterSection', { fg = colors.editor.fg_dark })
        -- end
        local starter = require('mini.starter')
        starter.setup({
            header = function()
                local hour = tonumber(vim.fn.strftime('%H'))
                -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
                local part_id = math.floor((hour + 4) / 8) + 1
                local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
                local username = "ワシーム"

                return ('Good %s, %s'):format(day_part, username)
            end,
        })
    end
}
