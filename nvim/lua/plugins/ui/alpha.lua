local function get_greeting(username)
    local hour = tonumber(vim.fn.strftime('%H'))
    -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
    local part_id = math.floor((hour + 4) / 8) + 1
    local day_part = ({ 'night', 'morning', 'afternoon', 'evening' })[part_id]

    return ('Good %s, %s'):format(day_part, username)
end


return {
    'goolord/alpha-nvim',
    enabled = true,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local alpha = require("alpha")
        vim.cmd [[
          highlight MyGreeting gui=bold guifg=#FFD700 cterm=bold ctermfg=220
        ]]
        local config = {
            layout = {
                { type = "padding", val = 20 }, -- vertical padding
                {
                    type = "text",
                    val = {
                        get_greeting("ワシーム"),
                    },
                    opts = {
                        position = "center",
                        hl = "MyGreeting",
                    },
                },
                { type = "padding", val = 2 },
                {
                    type = "text",
                    val = "Minimal. Intentional. Meaningful.",
                    opts = {
                        position = "center",
                        hl = "Comment",
                    },
                },
            },
            opts = {
                margin = 5,
            },
        }

        alpha.setup(config)

        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                vim.opt.laststatus = 0
            end,
        })

        vim.api.nvim_create_autocmd("WinClosed", {
            callback = function()
                local alpha_open = false
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "alpha" then
                        alpha_open = true
                        break
                    end
                end
                if not alpha_open then
                    vim.opt.laststatus = 2
                end
            end,
        })
    end
}
