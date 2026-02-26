local icons = require("core.icons")

return {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            setopt = true,
            thousands = false,
            relculright = false,
            ft_ignore = {
                "Outline",
                "Trouble",
                "neo-tree",
                "qf",
                'NvimTree',
                'alpha',
                'dap-repl',
                'dapui_breakpoints',
                'dapui_console',
                'dapui_scopes',
                'dapui_stacks',
                'dapui_watches',
                'help',
            },
            bt_ignore = { "nofile" },
            segments = {
                {
                    click = "v:lua.ScSa",
                    sign = {
                        name = { ".*" },
                        namespace = { ".*" },
                        maxwidth = 1,
                        foldclosed = true,
                    },
                },
                {
                    text = { builtin.lnumfunc, " " },
                    condition = { true, builtin.not_empty },
                    click = "v:lua.ScLa",
                },
                {
                    click = "v:lua.ScSa", -- Click to jump to the next Git change
                    sign = {
                        namespace = { "gitsigns.*" },
                        maxwidth = 1, -- Only need 1 character for Git signs
                        auto = true,
                    },
                },
                { text = { " " } },
            },
        })
    end,
}
