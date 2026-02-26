return {
    "mistweaverco/kulala.nvim",
    keys = {
        { "<leader>H", desc = "Kuala" },
        -- { "<leader>Hs", desc = "Kuala: Send request" },
        -- { "<leader>Ha", desc = "Kuala: Send all requests" },
        -- { "<leader>Hb", desc = "Kuala: Open scratchpad" },
        -- { "<leader>Ho", desc = "Kuala: Open" },
        -- { "<leader>Ht", desc = "Kuala: Toggle headers/body" },
        -- { "<leader>HS", desc = "Kuala: Show stats" },
        -- { "<leader>Hq", desc = "Kuala: Close window" },
        -- { "<leader>Hc", desc = "Kuala: Copy as cURL" },
        -- { "<leader>HC", desc = "Kuala: Paste from curl" },
        -- { "<leader>Hi", desc = "Kuala: Inspect current request" },
        -- { "<leader>Hj", desc = "Kuala: Open cookies jar" },
        -- { "<leader>Hr", desc = "Kuala: Replay the last request" },
        -- { "<leader>Hf", desc = "Kuala: Find request" },
        -- { "<leader>Hn", desc = "Kuala: Jump to next request" },
        -- { "<leader>Hp", desc = "Kuala: Jump to previous request" },
        -- { "<leader>He", desc = "Kuala: Select environment" },
        -- { "<leader>Hu", desc = "Kuala: Manage Auth Config" },
        -- { "<leader>Hg", desc = "Kuala: Download GraphQL schema" },
        -- { "<leader>Hx", desc = "Kuala: Clear globals" },
        -- { "<leader>HX", desc = "Kuala: Clear cached files" },
    },
    ft = { "http", "rest" },
    opts = {
        -- your configuration comes here
        global_keymaps = {
            ["Send request"] = { -- sets global mapping
                "<leader>Hs",
                function() require("kulala").run() end,
                mode = { "n", "v" },         -- optional mode, default is n
                desc = "Kuala: Send request" -- optional description, otherwise inferred from the key
            },
            ["Send all requests"] = {
                "<leader>Ha",
                function()
                    vim.ui.input({ prompt = "Send all requests? (y/n)" }, function(input)
                        if input == "y" then require("kulala").run_all() end
                    end)
                end,
                mode = { "n", "v" },
                ft = "http", -- sets mapping for *.http files only
            },
            ["Replay the last request"] = {
                "<leader>Hr",
                function() require("kulala").replay() end,
                ft = { "http", "rest" }, -- sets mapping for specified file types
            },
            ["Find request"] = false     -- set to false to disable
        },
        global_keymaps_prefix = "<leader>H",
        kulala_keymaps_prefix = "",
        kulala_keymaps = {
            ["Show headers"] = { "H", function() require("kulala.ui").show_headers() end, },
        },
        lsp = {
            keymaps = true, -- enables default Kulala's LSP keymaps
        },
    },
}
