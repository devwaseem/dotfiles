return {
    {
        'datsfilipe/vesper.nvim',
        enabled = false,
        opts = {
            transparent = false,  -- Boolean: Sets the background to transparent
            italics = {
                comments = true,  -- Boolean: Italicizes comments
                keywords = true,  -- Boolean: Italicizes keywords
                functions = true, -- Boolean: Italicizes functions
                strings = true,   -- Boolean: Italicizes strings
                variables = true, -- Boolean: Italicizes variables
            },
            overrides = {},       -- A dictionary of group names, can be a function returning a dictionary or a table.
            palette_overrides = {}
        }
    },
    {
        "serhez/teide.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "oskarnurm/koda.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("koda").setup({ transparent = false })
            -- vim.cmd("colorscheme koda")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        enabled = true,
        opts = {
            transparent_background = false,
        }
    },
    {
        "felipeagc/fleet-theme-nvim",
    },
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

                styles = { -- Give comments style such as bold, italic, underline etc.
                    comments = { italic = true --[[ italic = true ]] },
                    strings = { --[[ bold = true ]] },
                    keywords = { italic = true, bold = false --[[ underline = true ]] },
                    functions = { undercurl = false --[[ bold = true, undercurl = true ]] },
                    variables = { bold = false },
                    operators = { italic = true },
                    types = { italic = true },
                },

                plugins = { -- Uncomment the plugins that you use to highlight them
                    -- Available plugins:
                    "dap",
                    "blink",
                    -- "dashboard",
                    "eyeliner",
                    "fidget",
                    "flash",
                    "gitsigns",
                    "harpoon",
                    -- "hop",
                    "illuminate",
                    "indent-blankline",
                    -- "lspsaga",
                    "mini",
                    "neogit",
                    "neotest",
                    "neo-tree",
                    "neorg",
                    "neotest",
                    "nvim-navic",
                    "nvim-web-devicons",
                    "noice",
                    "nvim-cmp",
                    -- "nvim-tree",
                    "nvim-web-devicons",
                    "rainbow-delimiters",
                    -- "sneak",
                    "telescope",
                    "trouble",
                    "which-key",
                },
            })
        end,
    },
}
