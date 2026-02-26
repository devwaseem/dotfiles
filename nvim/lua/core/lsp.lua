local utils = require('core.utils')
local nmap = utils.nmap


local on_attach = function(client, bufnr)
    local lsp = vim.lsp
    if pcall(require, "telescope.builtin") then
        nmap({ 'gd', "<leader>ld" }, require('telescope.builtin').lsp_definitions, "go to Definitions",
            { buffer = bufnr })
        nmap({ 'gr', "<leader>lR" }, require('telescope.builtin').lsp_references, "go to References", { buffer = bufnr })
        nmap({ 'gT', "<leader>lT" }, require('telescope.builtin').lsp_type_definitions, "go to Type Definitions",
            { buffer = bufnr })
        nmap({ 'gI', "<leader>lI" }, require('telescope.builtin').lsp_implementations, "go to Implementations",
            { buffer = bufnr })
        nmap('<leader>lsw', require('telescope.builtin').lsp_workspace_symbols, "LSP Workspace Symbols",
            { buffer = bufnr })
        nmap('<leader>lsd', require('telescope.builtin').lsp_document_symbols, "LSP Document Symbols", { buffer = bufnr })
        nmap('<leader>led', function() require('telescope.builtin').diagnostics({ bufnr = bufnr }) end,
            "LSP Document Diagnostics", { buffer = bufnr })
        nmap('<leader>lew', function() require('telescope.builtin').diagnostics() end,
            "LSP Workspace Diagnostics", { buffer = bufnr })
    else
        nmap({ 'gd', "<leader>lD" }, lsp.buf.definition, "go to Definitions", { buffer = bufnr })
        nmap({ 'gr', "<leader>lR" }, lsp.buf.references, "go to References", { buffer = bufnr })
        nmap({ 'gT', "<leader>lT" }, lsp.buf.type_definition, "go to Type Definitions", { buffer = bufnr })
        nmap({ 'gI', "<leader>gI" }, lsp.buf.implementation, "go to Implementations", { buffer = bufnr })
    end

    if pcall(require, "conform") then
        nmap("<leader>lf", "<cmd>Format<CR>", "Format Code", { buffer = bufnr })
    else
        nmap("<leader>lf", function() vim.lsp.buf.format { async = true } end, "LSP Format Code", { buffer = bufnr })
    end

    nmap("<leader>lE", vim.diagnostic.open_float, "LSP Show Diagnostic", { buffer = bufnr })
    nmap({ 'gD', "<leader>lD" }, lsp.buf.declaration, "go to Declaration", { buffer = bufnr })
    nmap({ 'K', "<leader>lK" }, lsp.buf.hover, "LSP Hover", { buffer = bufnr })
    nmap("<leader>la", lsp.buf.code_action, "LSP Code Actions", { buffer = bufnr })

    if pcall(require, "live-rename") then
        nmap("<leader>lr", require("live-rename").rename, "LSP Rename Symbol", { buffer = bufnr })
    else
        nmap("<leader>lr", lsp.buf.rename, "LSP Rename Symbol", { buffer = bufnr })
    end

    local ok, navbuddy = pcall(require, "nvim-navbuddy")
    if ok and navbuddy and navbuddy.attach then
        navbuddy.attach(client, bufnr)
    end
end


local capabilities = nil
if pcall(require, "blink.cmp") then
    capabilities = require('blink.cmp').get_lsp_capabilities()
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
end


local enabled_servers = {
    'tailwindcss',
    'ts_ls',
    'basedpyright',
    'lua_ls',
    'jsonls',
    'postgrestools',
    'groovyls',
    "ruff",
    "rust_analyzer",
    "nil_ls",
}

for _, server in ipairs(enabled_servers) do
    vim.lsp.config(server, vim.tbl_deep_extend("force", vim.lsp.config[server], {
        on_attach = on_attach,
        capabilities = capabilities,
    }))
    vim.lsp.enable(server)
end
