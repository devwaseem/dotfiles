local palette = require("core.palette")

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = true,
                term_colors = true,
                no_bold = true,
                no_italic = true,
                no_underline = true,
                color_overrides = {
                    mocha = palette,
                },
                lsp_styles = {
                    inlay_hints = {
                        background = true,
                    },
                },
                auto_integrations = true,
                integrations = {
                    blink_cmp = {
                        style = "bordered",
                    },
                    gitsigns = true,
                    flash = true,
                    neotree = true,
                    render_markdown = true,
                    snacks = {
                        enabled = true,
                    },
                    telescope = {
                        enabled = true,
                    },
                    treesitter_context = true,
                    which_key = true,
                },
                highlight_overrides = {
                    mocha = function(colors)
                        return {
                            NormalFloat = { bg = colors.mantle },
                            FloatBorder = { bg = colors.mantle, fg = colors.surface2 },
                            FloatTitle = { bg = colors.mantle, fg = colors.text },
                            Pmenu = { bg = colors.mantle, fg = colors.text },
                            PmenuSel = { bg = colors.surface0, fg = colors.text },
                            PmenuSbar = { bg = colors.surface0 },
                            PmenuThumb = { bg = colors.surface2 },
                            LineNr = { fg = colors.overlay0 },
                            CursorLineNr = { fg = colors.text },
                            IblIndent = { fg = colors.surface0 },
                            IblScope = { fg = colors.overlay0 },
                            GitSignsChange = { fg = colors.peach },
                            VertSplit = { bg = colors.base, fg = colors.surface0 },
                            WinSeparator = { bg = colors.base, fg = colors.surface0 },
                        }
                    end,
                },
            })
        end,
    },
}
