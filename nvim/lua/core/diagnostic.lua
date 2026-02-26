local M = {}

M.disable_diagnostic = function()
    vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = false,
        underline = false
    })
end

M.enable_diagnostic = function()
    local is_lsplines_enabled = vim.g.is_lsplines_enabled
    if pcall(require, 'lsp_lines') and is_lsplines_enabled then
        vim.diagnostic.config({
            virtual_lines = {
                only_current_line = false,
                highlight_whole_line = false,
            },
            virtual_text = false,
            underline = {
                severity = { min = vim.diagnostic.severity.WARN },
            },
        })
    else
        vim.diagnostic.config({
            virtual_lines = false,
            virtual_text = {
                source = "always"
            },
            underline = {
                severity = { min = vim.diagnostic.severity.WARN },
            },
        })
    end
end

return M
