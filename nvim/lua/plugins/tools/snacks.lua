return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = true },
        input = {
            enabled = true,
        },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        indent = {
            indent = {
                priority = 1,
                enabled = true,
            },
            scope = {
                enabled = true,
            },
            chunk = {
                enabled = true,
                char = {
                    arrow = "─"
                },
            },
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                -- enabled = false,
                duration = {
                    step = 10,   -- ms per step
                    total = 500, -- maximum duration
                },
            },
            filter = function(buf)
                return vim.g.snacks_indent ~= false
                    and vim.b[buf].snacks_indent ~= false
                    and vim.bo[buf].ft ~= ""
                    and vim.bo[buf].ft ~= "wk"
                    and vim.bo[buf].ft ~= "qf"
                    and vim.bo[buf].ft ~= "help"
                    and vim.bo[buf].ft ~= "dapui_scopes"
                    and vim.bo[buf].ft ~= "dapui_watches"
                    and vim.bo[buf].ft ~= "dapui_stacks"
                    and vim.bo[buf].ft ~= "dapui_breakpoints"
                    and vim.bo[buf].ft ~= "dapui_console"
                    and vim.bo[buf].ft ~= "dap-repl"
                    and vim.bo[buf].ft ~= "harpoon"
                    and vim.bo[buf].ft ~= "dropbar_menu"
                    and vim.bo[buf].ft ~= "glow"
                    and vim.bo[buf].ft ~= "aerial"
                    and vim.bo[buf].ft ~= "dashboard"
                    and vim.bo[buf].ft ~= "lspinfo"
                    and vim.bo[buf].ft ~= "lspsagafinder"
                    and vim.bo[buf].ft ~= "packer"
                    and vim.bo[buf].ft ~= "checkhealth"
                    and vim.bo[buf].ft ~= "man"
                    and vim.bo[buf].ft ~= "mason"
                    and vim.bo[buf].ft ~= "noice"
                    and vim.bo[buf].ft ~= "NvimTree"
                    and vim.bo[buf].ft ~= "neo-tree"
                    and vim.bo[buf].ft ~= "plugin"
                    and vim.bo[buf].ft ~= "lazy"
                    and vim.bo[buf].ft ~= "TelescopePrompt"
                    and vim.bo[buf].ft ~= "alpha"
                    and vim.bo[buf].ft ~= "toggleterm"
                    and vim.bo[buf].ft ~= "sagafinder"
                    and vim.bo[buf].ft ~= "sagaoutline"
                    and vim.bo[buf].ft ~= "better_term"
                    and vim.bo[buf].ft ~= "fugitiveblame"
                    and vim.bo[buf].ft ~= "Trouble"
                    and vim.bo[buf].ft ~= "Outline"
                    and vim.bo[buf].ft ~= "OutlineHelp"
                    and vim.bo[buf].ft ~= "starter"
                    and vim.bo[buf].ft ~= "NeogitPopup"
                    and vim.bo[buf].ft ~= "NeogitStatus"
                    and vim.bo[buf].ft ~= "DiffviewFiles"
                    and vim.bo[buf].ft ~= "DiffviewFileHistory"
                    and vim.bo[buf].ft ~= "DressingInput"
                    and vim.bo[buf].ft ~= "spectre_panel"
                    and vim.bo[buf].ft ~= "zsh"
                    and vim.bo[buf].ft ~= "vuffers"
                    and vim.bo[buf].ft ~= "oil"
                    and vim.bo[buf].ft ~= "oil_preview"
                    and vim.bo[buf].ft ~= "NeogitConsole"
                    and vim.bo[buf].ft ~= "text"
                    and vim.bo[buf].ft ~= "AvanteInput"
                    and vim.bo[buf].ft ~= "buffer_manager"
                    and vim.bo[buf].ft ~= "snacks_picker_list"
                    and vim.bo[buf].ft ~= "snacks_picker_input"
                    and vim.bo[buf].ft ~= "markdown"
            end,
        },

    },
}
