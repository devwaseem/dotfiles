return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
    },
    keys = {
        -- Toggle
        { "<leader>ufd", "<cmd>:FormatDisable<CR>", desc = "Disable Auto Formatting on Save" },
        { "<leader>ufe", "<cmd>:FormatEnable<CR>",  desc = "Enable Auto Formatting on Save" },
        {
            "<leader>lf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        }

    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opt)
        if pcall(require, 'which-key') then
            local wk = require('which-key')
            wk.add({
                { "<leader>uf", name = "Auto Formatting on Save", }
            })
        end

        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = {
                    "ruff_format",
                    "ruff_fix",
                },
                -- Use a sub-list to run only the first available formatter
                javascript = {
                    "prettierd", "prettier", stop_after_first = true,
                },
                typescript = {
                    "prettierd", "prettier", stop_after_first = true,
                },
                astro = {
                    "prettierd", "prettier", stop_after_first = true,
                },
                json = { "jq" },
                jq = { "jq" },
                html = { "djlint", "prettierd", "prettier", stop_after_first = true },
                htmldjango = { "djlint" },
                sql = { "sqruff", "pg_format" }
            },

            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
        })



        vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end,
            {
                range = true
            }
        )

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })

        vim.keymap.set("", "<leader>f", function()
            require("conform").format({ async = true }, function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    end
                end
            end)
        end, { desc = "Format code" })
    end
}
