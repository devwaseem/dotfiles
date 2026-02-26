local dmypy_started = false

local find_cmd = function(paths, default)
    return function()
        for _, path in ipairs(paths) do
            local cmd = vim.fn.fnamemodify(path, ':p')
            local stat = vim.loop.fs_stat(cmd)
            if stat then
                return cmd
            end
        end
        return default
    end
end

return {
    "mfussenegger/nvim-lint",
    dependencies = {
        "rshkarin/mason-nvim-lint",
    },
    enabled = true,
    ft = {
        'javascript',
        'javascriptreact',
        'python',
        "htmldjango",
        "html",
    },
    event = { "BufEnter", },
    config = function()
        -- require('mason-nvim-lint').setup({
        --     ensure_installed = {
        --         -- "mypy",
        --         -- 'ruff',
        --         -- "djlint",
        --         -- "semgrep",
        --         -- "dotenv-linter",
        --         -- "bandit",
        --         -- "hadolint",
        --         -- "trivy",
        --         -- "semgrep",
        --     },
        --     automatic_installation = true,
        -- })

        local lint = require('lint')

        lint.linters.mypy.cmd = find_cmd({
            ".venv/bin/mypy"
        }, "mypy")

        lint.linters.mypy.args = {
            "--config-file", "pyproject.toml"
        }

        lint.linters.bandit.cmd = find_cmd({
            ".venv/bin/bandit"
        }, "bandit")

        lint.linters.bandit.args = {
            "-c", "pyproject.toml"
        }

        lint.linters.vulture.cmd = find_cmd({
            ".venv/bin/vulture"
        }, "vulture")

        lint.linters.djlint.args = {
            "--configuration", "pyproject.toml", "--preserve-blank-lines"
        }


        lint.linters_by_ft = {
            markdown = {
                -- "vale",
                -- "markdownlint",
                "codespell",
            },
            quarto = {
                "codespell",
            },
            txt = {
                "codespell",
            },
            python = {
                -- 'ruff',
                'mypy',
                "bandit",
                -- "vulture",
            },
            sh = { "shellcheck" },
            htmldjango = {
                "djlint",
            },
            html = {
                "djlint",
            },
            dockerfile = {
                "hadolint",
            },
            javascript = {
                "eslint_d",
            },
            javascriptreact = {
                "eslint_d",
            },
            typescript = {
                "eslint_d",
            },
            ["javascript.jsx"] = {
                "eslint_d",
            },
            typescriptreact = {
                "eslint_d",
            },
            ["typescript.tsx"] = {
                "eslint_d",
            },
            css = { "eslint_d" },
            json = { "jsonlint" },
        }

        vim.api.nvim_create_autocmd({
            "BufWritePost",
        }, {
            callback = function()
                lint.try_lint()
            end,
        })

        -- vim.api.nvim_create_autocmd({
        --     "InsertLeave",
        -- }, {
        --     pattern = 'python',
        --     callback = function()
        --         lint.try_lint('ruff')
        --     end,
        -- })

        local nmap = require('core.utils').nmap
        nmap('<leader>ll', function()
            lint.try_lint()
        end, "Run Linter")
    end
}
