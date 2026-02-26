local toggle = function()
    vim.g.is_lsplines_enabled = not vim.g.is_lsplines_enabled
    if vim.g.is_lsplines_enabled then
        vim.notify("LSP Lines toggled")
    else
        vim.notify("LSP Lines disabled")
    end
end

return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = false,
    event = "LspAttach",
    config = function()
        require("lsp_lines").setup()
        vim.g.is_lsplines_enabled = true
        vim.diagnostic.config({
            virtual_lines = {
                only_current_line = false,
                highlight_whole_line = false,
            },
            virtual_text = false,
            underline = {
                severity = { min = vim.diagnostic.severity.WARN },
            }
        })
        vim.keymap.set(
            "",
            "<Leader>ul",
            toggle,
            { desc = "Toggle lsp_lines" }
        )

        -- vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', {
        --     fg = '#ff5370',
        --     bg = "NONE"
        -- })
    end,
}
