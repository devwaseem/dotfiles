return {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
        { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" }
    },
    opts = {
        window = {
            backdrop = 0.75,
            height = 1
        },
        plugins = {
            tmux = { enabled = true },
            twilight = { enabled = false },
            wezterm = {
                enabled = false,
                -- can be either an absolute font size or the number of incremental steps
                font = "+4", -- (10% increase per step)
            },
        }
    }
}
