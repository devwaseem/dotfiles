return {
    {
        "marko-cerovac/material.nvim",
        priority = 1000,
        config = function()
            vim.g.material_style = "deep ocean"
            require('material').setup({
                async_loading = true,
                disable = {
                    background = true,
                },

                custom_colors = function(colors)
                    colors.editor.accent = colors.main.darkyellow
                end,

                contrast = {
                    terminal = true,             -- Enable contrast for the built-in terminal
                    sidebars = true,             -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
                    floating_windows = true,     -- Enable contrast for floating windows
                    cursor_line = false,         -- Enable darker background for the cursor line
                    lsp_virtual_text = true,     -- Enable contrasted background for lsp virtual text
                    non_current_windows = false, -- Enable contrasted background for non-current windows
                    filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
                },

                styles = {
                    comments = { italic = true },
                    strings = {},
                    keywords = { italic = true, bold = false },
                    functions = { undercurl = false },
                    variables = { bold = false },
                    operators = { italic = true },
                    types = { italic = true },
                },

                plugins = {
                    "dap",
                    "blink",
                    "eyeliner",
                    "fidget",
                    "flash",
                    "gitsigns",
                    "harpoon",
                    "illuminate",
                    "mini",
                    "neogit",
                    "neotest",
                    "neo-tree",
                    "nvim-web-devicons",
                    "noice",
                    "rainbow-delimiters",
                    "telescope",
                    "trouble",
                    "which-key",
                },
            })
        end,
    },
}
