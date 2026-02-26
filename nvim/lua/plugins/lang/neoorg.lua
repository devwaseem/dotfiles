return {
    "nvim-neorg/neorg",
    enabled = false,
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},  -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.ui"] = {},
                ["core.presenter"] = {
                    config = {
                        zen_mode = "zen-mode"
                    }
                },
                ["core.integrations.treesitter"] = {},

                ["core.completion"] = {
                    config = { engine = "nvim-cmp" }
                },
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/Notes",
                        },
                    },
                },
            },
        }
    end,
}
