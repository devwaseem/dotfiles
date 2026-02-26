return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
    },
    keys = {
        {
            "<leader>rs",
            function()
                require('neotest').run.stop()
            end,
            desc = "Stop nearest test",
        },
        {
            "<leader>ra",
            function()
                require('neotest').run.attach()
            end,
            desc = "Attach nearest test",
        },
        {
            "<leader>rc",
            function()
                require('neotest').run.run()
            end,
            desc = "Run nearest test",
        },
        {
            "<leader>rC",
            function()
                require('neotest').run.run({ strategy = "dap" })
            end,
            desc = "Run nearest test using debugger",
        },
        {
            "<leader>rf",
            function()
                require('neotest').run.run({ vim.fn.expand("%") })
            end,
            desc = "Run all tests in current file",
        },
        {
            "<leader>rF",
            function()
                require('neotest').run.run({ vim.fn.expand("%"), strategy = "dap" })
            end,
            desc = "Run all tests in current file with debugger",
        },
        {
            "<leader>rwt",
            function()
                require('neotest').watch.toggle()
            end,
            desc = "Toggle watch nearest test",
        },
        {
            "<leader>rws",
            function()
                require('neotest').watch.stop()
            end,
            desc = "Stop watching nearest test",
        },
        {
            "<leader>rk",
            function()
                require('neotest').output.open()
            end,
            desc = "Open output panel",
        },
        {
            "<leader>ro",
            function()
                require('neotest').output_panel.toggle()
            end,
            desc = "Toggle output panel",
        },
        {
            "<leader>ro",
            function()
                require('neotest').summary.toggle()
            end,
            desc = "Toggle Summary panel",
        }

    },
    config = function()
        require('neotest').setup {
            adapters = {
                require('neotest-python')({
                    dap = { justMyCode = false },
                    args = {
                        -- '--reuse-db',
                        -- '-v',
                        -- '--capture=sys',
                        -- '--no-migrations',
                        '--color=yes',
                        '--strict-markers',
                        '--strict-config',
                        '--tb=short',
                        -- '--tb=long',
                        '--no-cov',
                    },
                    runner = "pytest",
                    python = ".venv/bin/python"
                })
            }
        }
    end
}
