return {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    ft = "python",
    -- cmd = "VenvSelect",
    -- keys = { { "<leader>lv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
    config = function(_, opts)
        if pcall(require, "nvim-dap-python") then
            opts.dap_enabled = true
        end
        opts = vim.tbl_deep_extend("force", opts, {
            name = {
                "venv",
                ".venv",
                "env",
                ".env",
            },
            poetry_path = "./"
        })
        opts.enable_cached_venvs = true
        require('venv-selector').setup(opts)
    end,
}
