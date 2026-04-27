local icons = require("core.icons")
vim.g.show_file_metadata = false
local function toggle_file_metadata()
    vim.g.show_file_metadata = not vim.g.show_file_metadata
end

local function can_show_file_metadata()
    return vim.g.show_file_metadata
end

local function IsZoomedIn()
    if vim.t['simple-zoom'] == nil then
        return ''
    elseif vim.t['simple-zoom'] == 'zoom' then
        return '󰍉'
    end
end


local function get_ts_lang()
    local ok, parser = pcall(vim.treesitter.get_parser, 0)
    if not ok or not parser then return "" end

    -- This returns the primary language of the buffer
    return " " .. parser:lang()
end


local icons = require("core.icons")
local function indent_settings()
    return (vim.bo.expandtab and "S" or "T")
        .. ":"
        .. (vim.bo.shiftwidth == 0 and vim.bo.tabstop or vim.bo.shiftwidth)
end

local function is_not_popup()
    local types = {
        "TelescopePrompt"
    }

    return not vim.tbl_contains(types, vim.bo.filetype)
end

local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
}

return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        "marko-cerovac/material.nvim",
        "pnx/lualine-lsp-status",
        {
            "letieu/harpoon-lualine",
            dependencies = {
                {
                    "ThePrimeagen/harpoon",
                    branch = "harpoon2",
                }
            },
        },
    },
    config = function()
        local custom_theme = nil
        if vim.g.colors_name == 'material' and pcall(require, 'material') then
            local mcolors = require('material.colors')
            local m = mcolors.main
            local e = mcolors.editor
            local none = 'None'
            local fg = e.line_numbers
            custom_theme = {
                normal = {
                    a = { fg = e.fg, bg = none, gui = "bold" },
                    b = { fg = fg, bg = none, gui = "italic" },
                    c = { fg = fg, bg = none, gui = "italic" },

                    z = { fg = fg, bg = none, gui = "bold" },

                },
                insert = {
                    a = { fg = m.black, bg = m.darkgreen, gui = "bold" },
                    b = { fg = fg, bg = none, gui = "italic" },
                    c = { fg = fg, bg = none, gui = "italic" },

                    z = { fg = m.darkgreen, bg = none, gui = "bold" },
                },
                visual = {
                    a = { fg = m.black, bg = m.darkred, gui = "bold" },
                    b = { fg = fg, bg = none, gui = "italic" },
                    c = { fg = fg, bg = none, gui = "italic" },

                    z = { fg = m.darkred, bg = none, gui = "bold" },
                },
                replace = {
                    a = { fg = m.black, bg = m.paleblue, gui = "bold" },
                    b = { fg = fg, bg = none, gui = "italic" },
                    c = { fg = fg, bg = none, gui = "italic" },

                    z = { fg = m.paleblue, bg = none, gui = "bold" },
                },

                inactive = {
                    a = { fg = colors.white, bg = none },
                    b = { fg = colors.white, bg = none },
                    c = { fg = colors.black, bg = none },
                },
            }
        end

        local options = {
            -- component_separators = { left = '›', right = '‹' },
            component_separators = {
                left = icons.lualine.separators.component.left,
                right = icons.lualine.separators.component.right,
            },
            section_separators = { right = '' },
            disabled_filetypes = { "alpha", "NvimTree", "undotree", "fugitive", "TelescopePrompt", "mason", "lazy" },
        }

        if custom_theme then
            options.theme = custom_theme
        end

        vim.keymap.set(
            "n",
            "<leader>uF",
            toggle_file_metadata,
            { desc = "Toggle File Metadata" }
        )

        require('lualine').setup {
            options = options,
            sections = {
                lualine_a = {
                    -- { 'mode' },
                    {
                        require("noice").api.status.mode.get,
                        cond = require("noice").api.status.mode.has,
                        separator = { left = '', right = '' },
                        -- right_padding = 2
                    },
                },
                lualine_b = {
                    { 'filename' },
                    { IsZoomedIn },
                    {
                        'branch',
                        on_click = function()
                            vim.cmd [[ LazyGit ]]
                        end
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.diff.added .. " ",
                            modified = icons.diff.modified .. " ",
                            removed = icons.diff.removed .. " ",
                        },
                        on_click = function(_, btn, _)
                            require('gitsigns').diffthis()
                        end
                    },
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.error .. " ",
                            warn = icons.diagnostics.warn .. " ",
                            info = icons.diagnostics.info .. " ",
                            hint = icons.diagnostics.hint .. " ",
                        },
                        on_click = function(_, btn, _)
                            vim.cmd [[ Trouble diagnostics ]]
                        end
                    },
                },
                lualine_c = {
                    -- {
                    --     "lsp-status",
                    --     disabled_filetypes = {
                    --         "TelescopePrompt",
                    --     },
                    --     on_click = function(_, btn, _)
                    --         vim.cmd [[ checkhealth vim.lsp ]]
                    --     end
                    -- },
                    { 'searchcount' },
                    { 'selectioncount' },
                    -- { require("recorder").recordingStatus },
                    -- { require("recorder").displaySlots },
                },
                lualine_x = {
                    {
                        "harpoon2",
                        icon = '♥',
                        indicators = { "1", "2", "3", "4" },
                        active_indicators = { "1", "2", "3", "4" },
                        color_active = { fg = colors.violet },
                        _separator = " ",
                        no_harpoon = "Harpoon not loaded",
                    },
                },
                lualine_y = {
                    { 'spelunk' },
                    {
                        function()
                            local status = require("sidekick.status").cli()
                            return " " .. (#status > 1 and #status or "")
                        end,
                        cond = function()
                            return #require("sidekick.status").cli() > 0
                        end,
                        color = function()
                            return "Special"
                        end,
                    },
                    {
                        function()
                            return "Supermaven"
                        end,
                        icon = "󱡄",
                        cond = require('supermaven-nvim.api').is_running,
                    },
                    {
                        function()
                            local clients = vim.lsp.get_clients({ bufnr = 0 })
                            if next(clients) == nil then
                                return '' -- No LSP attached
                            end
                            local lsp_names = {}
                            for _, client in pairs(clients) do
                                table.insert(lsp_names, client.name)
                            end
                            return table.concat(lsp_names, ', ')
                        end,
                        icon = '', -- Optional icon
                        on_click = function()
                            vim.cmd [[ checkhealth vim.lsp ]]
                        end
                    },
                    {
                        require("noice").api.status.search.get,
                        cond = require("noice").api.status.search.has,
                    },
                    {
                        get_ts_lang
                    },
                    {
                        "filetype",
                        cond = function()
                            return can_show_file_metadata() and is_not_popup()
                        end
                    },
                    {
                        "fileformat",
                        symbols = {
                            unix = "NL",
                            dos = "NLCR",
                            mac = 'NL'
                        },
                        cond = can_show_file_metadata,
                    },
                    {
                        indent_settings,
                        cond = can_show_file_metadata,
                    },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        'encoding',
                        on_click = function()
                            toggle_file_metadata()
                        end
                    },
                    { 'progress' },
                },
                lualine_z = {
                    { 'location', icon = "" }
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            extensions = {
                "lazy",
                "neo-tree",
                "fugitive",
                "trouble",
                "nvim-tree",
                "symbols-outline",
                "quickfix",
                "toggleterm",
                "nvim-dap-ui",
            },
        }

        vim.cmd [[hi StatusLine guibg=NONE]]

        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                require("lualine").hide()
            end,
        })
        vim.api.nvim_create_autocmd("BufLeave", {
            pattern = "*",
            callback = function()
                require("lualine").hide({ unhide = true })
            end,
        })
    end
}
