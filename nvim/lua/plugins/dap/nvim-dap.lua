return {
    'mfussenegger/nvim-dap',
    event = "VeryLazy",
    dependencies = {
        'rcarriga/nvim-dap-ui',
        "nvim-neotest/nvim-nio",
        'jay-babu/mason-nvim-dap.nvim',
        'mfussenegger/nvim-dap-python',
        'nvim-telescope/telescope-dap.nvim',
        "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
        { '<leader>db', function() require('dap').toggle_breakpoint() end,                                   desc = 'Toggle Breakpoint' },
        { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint Condition: ') end, desc = 'Set Conditional Breakpoint' },
        { '<leader>dc', function() require('dap').continue() end,                                            desc = 'Continue Execution' },
        { '<leader>ds', function() require('dap').step_into() end,                                           desc = 'Step Into' },
        { '<leader>do', function() require('dap').step_over() end,                                           desc = 'Step Over' },
        { '<leader>dO', function() require('dap').step_out() end,                                            desc = 'Step Out' },
        { '<leader>dr', function() require('dap').repl.open() end,                                           desc = 'Open REPL' },
        { '<leader>dl', function() require('dap').run_last() end,                                            desc = 'Run Last Debug Session' },
        { '<leader>dk', function() require('dap').terminate() end,                                           desc = 'Terminate Debug Session' },
        { '<leader>dK', function() require('dap').close() end,                                               desc = 'Close Debug Session' },
        { '<leader>dp', function() require('dap').pause() end,                                               desc = 'Pause Debug Session' },
        { '<leader>du', function() require('dap').up() end,                                                  desc = 'Up Stack Frame' },
        { '<leader>dd', function() require('dap').down() end,                                                desc = 'Down Stack Frame' },
        { '<leader>dt', function() require('dap').toggle() end,                                              desc = 'Toggle Debug' },
        { '<leader>dv', function() require('dap').variables() end,                                           desc = 'View Variables' },
        { '<leader>dR', function() require('dap').run_to_cursor() end,                                       desc = 'Run to cursor' },
        { '<leader>dd', function() require('dap').disconnect() end,                                          desc = 'Disconnect' },
        { '<leader>dD', function() require('dap').terminate() end,                                           desc = 'Terminate' },
        { '<leader>dl', function() require('dap').run_last() end,                                            desc = 'Run Last' },
        { '<leader>dt', function() require('dapui').toggle() end,                                            desc = 'Toggle UI' },
    },
    config = function()
        -- setup dap python
        local dap_python = require('dap-python')
        dap_python.setup('./.venv/bin/python')
        dap_python.test_runner = { 'pytest', 'unittest' }

        require('mason-nvim-dap').setup({
            automatic_installation = true,
            ensure_installed = {
                'python',
                'node',
            },
            handlers = {
                function(config)
                    -- all sources with no handler get passed here

                    -- Keep original functionality
                    require('mason-nvim-dap').default_setup(config)
                end,
                python = function(config)
                    config.adapters = {
                        type = 'executable',
                        command = 'python',
                        args = { '-m', 'debugpy.adapter' },
                    }
                    require('mason-nvim-dap').default_setup(config) -- don't forget this!
                end,
            }
        })

        -- Setup DAP UI
        local dapui = require('dapui')
        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸', current_frame = '󰎂' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                }
            }
        }

        local dap = require('dap')

        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

        local signs = {
            Breakpoint = "",
            BreakpointCondition = "",
            BreakpointRejected = "",
        }

        for type, icon in pairs(signs) do
            local hl = "Dap" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = "DiagnosticSignError", numhl = "" })
        end

        vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignOk", numhl = "" })

        -- Setup virtual text for DAP
        require('nvim-dap-virtual-text').setup()

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Django: Run Server',
                program = '${workspaceFolder}/manage.py',
                args = { 'runserver', '--noreload', '0.0.0.0:8000', },
                django = true,
                justMyCode = false,
                console = 'integratedTerminal',
            },
            {
                type = 'python',
                request = 'launch',
                name = "Django: Attach Remote",
                connect = {
                    host = "127.0.0.1",
                    port = 5678
                },
                pathMappings = {
                    { localRoot = "${workspaceFolder}", remoteRoot = "/app" }
                },
                django = true,
                justMyCode = false,
            }
        }
    end
}
