local icons = require("core.icons")

vim.g.show_file_metadata = false

local function toggle_file_metadata()
    vim.g.show_file_metadata = not vim.g.show_file_metadata
end

local function can_show_file_metadata()
    return vim.g.show_file_metadata
end

local function is_zoomed_in()
    return vim.t.simple_zoom == "zoom" and "󰍉" or ""
end

local function indent_settings()
    return (vim.bo.expandtab and "S" or "T")
        .. ":"
        .. (vim.bo.shiftwidth == 0 and vim.bo.tabstop or vim.bo.shiftwidth)
end

local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local names = {}

    for _, client in pairs(clients) do
        table.insert(names, client.name)
    end

    return table.concat(names, ", ")
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "marko-cerovac/material.nvim",
        {
            "letieu/harpoon-lualine",
            dependencies = {
                {
                    "ThePrimeagen/harpoon",
                    branch = "harpoon2",
                },
            },
        },
    },
    config = function()
        local custom_theme

        if vim.g.colors_name == "material" and pcall(require, "material") then
            local colors = require("material.colors")
            local main = colors.main
            local editor = colors.editor
            local none = "None"

            custom_theme = {
                normal = {
                    a = { fg = editor.fg, bg = none, gui = "bold" },
                    b = { fg = editor.line_numbers, bg = none },
                    c = { fg = editor.line_numbers, bg = none },
                    z = { fg = editor.line_numbers, bg = none, gui = "bold" },
                },
                insert = {
                    a = { fg = main.black, bg = main.darkgreen, gui = "bold" },
                    b = { fg = editor.line_numbers, bg = none },
                    c = { fg = editor.line_numbers, bg = none },
                    z = { fg = main.darkgreen, bg = none, gui = "bold" },
                },
                visual = {
                    a = { fg = main.black, bg = main.darkred, gui = "bold" },
                    b = { fg = editor.line_numbers, bg = none },
                    c = { fg = editor.line_numbers, bg = none },
                    z = { fg = main.darkred, bg = none, gui = "bold" },
                },
                replace = {
                    a = { fg = main.black, bg = main.paleblue, gui = "bold" },
                    b = { fg = editor.line_numbers, bg = none },
                    c = { fg = editor.line_numbers, bg = none },
                    z = { fg = main.paleblue, bg = none, gui = "bold" },
                },
                inactive = {
                    a = { fg = editor.line_numbers, bg = none },
                    b = { fg = editor.line_numbers, bg = none },
                    c = { fg = editor.line_numbers, bg = none },
                },
            }
        end

        vim.keymap.set("n", "<leader>uF", toggle_file_metadata, { desc = "Toggle status metadata" })

        require("lualine").setup({
            options = {
                theme = custom_theme,
                globalstatus = true,
                component_separators = {
                    left = icons.lualine.separators.component.left,
                    right = icons.lualine.separators.component.right,
                },
                section_separators = { right = "" },
                disabled_filetypes = { "alpha", "fugitive", "TelescopePrompt", "lazy", "mason", "undotree" },
            },
            sections = {
                lualine_a = {
                    {
                        require("noice").api.status.mode.get,
                        cond = require("noice").api.status.mode.has,
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = {
                    { "filename" },
                    { is_zoomed_in },
                    {
                        "branch",
                        on_click = function()
                            vim.cmd("LazyGit")
                        end,
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.diff.added .. " ",
                            modified = icons.diff.modified .. " ",
                            removed = icons.diff.removed .. " ",
                        },
                        on_click = function()
                            require("gitsigns").diffthis()
                        end,
                    },
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.error .. " ",
                            warn = icons.diagnostics.warn .. " ",
                            info = icons.diagnostics.info .. " ",
                            hint = icons.diagnostics.hint .. " ",
                        },
                        on_click = function()
                            vim.cmd("Trouble diagnostics")
                        end,
                    },
                },
                lualine_c = {
                    { "searchcount" },
                    { "selectioncount" },
                },
                lualine_x = {
                    {
                        "harpoon2",
                        icon = "♥",
                        indicators = { "1", "2", "3", "4" },
                        active_indicators = { "1", "2", "3", "4" },
                        no_harpoon = "",
                    },
                },
                lualine_y = {
                    {
                        function()
                            local status = require("sidekick.status").cli()
                            return " " .. (#status > 1 and #status or "")
                        end,
                        cond = function()
                            return #require("sidekick.status").cli() > 0
                        end,
                        color = "Special",
                    },
                    {
                        lsp_clients,
                        icon = "",
                        cond = can_show_file_metadata,
                        on_click = function()
                            vim.cmd("checkhealth vim.lsp")
                        end,
                    },
                    {
                        require("noice").api.status.search.get,
                        cond = require("noice").api.status.search.has,
                    },
                    {
                        "filetype",
                        cond = can_show_file_metadata,
                    },
                    {
                        indent_settings,
                        cond = can_show_file_metadata,
                    },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = "#d9a441" },
                    },
                },
                lualine_z = {
                    { "location", icon = "" },
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
                "quickfix",
                "toggleterm",
                "nvim-dap-ui",
            },
        })

        vim.cmd("hi StatusLine guibg=NONE")

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
    end,
}
