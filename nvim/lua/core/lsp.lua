local utils = require('core.utils')
local nmap = utils.nmap

local function telescope_picker(picker, opts)
    return function()
        local ok, builtin = pcall(require, 'telescope.builtin')
        if ok then
            builtin[picker](opts)
            return
        end

        vim.notify('Telescope is unavailable', vim.log.levels.WARN)
    end
end

local on_attach = function(client, bufnr)
    local lsp = vim.lsp
    nmap({ 'gd', "<leader>ld" }, telescope_picker('lsp_definitions'), "go to Definitions", { buffer = bufnr })
    nmap({ 'gr', "<leader>lR" }, telescope_picker('lsp_references'), "go to References", { buffer = bufnr })
    nmap({ 'gT', "<leader>lT" }, telescope_picker('lsp_type_definitions'), "go to Type Definitions", { buffer = bufnr })
    nmap({ 'gI', "<leader>lI" }, telescope_picker('lsp_implementations'), "go to Implementations", { buffer = bufnr })
    nmap('<leader>lsw', telescope_picker('lsp_workspace_symbols'), "LSP Workspace Symbols", { buffer = bufnr })
    nmap('<leader>lsd', telescope_picker('lsp_document_symbols'), "LSP Document Symbols", { buffer = bufnr })
    nmap('<leader>led', telescope_picker('diagnostics', { bufnr = bufnr }), "LSP Document Diagnostics", { buffer = bufnr })
    nmap('<leader>lew', telescope_picker('diagnostics'), "LSP Workspace Diagnostics", { buffer = bufnr })

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

    if client.name == 'ruff' then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
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
    "nixd",
}

for _, server in ipairs(enabled_servers) do
    vim.lsp.config(server, vim.tbl_deep_extend("force", vim.lsp.config[server], {
        on_attach = on_attach,
        capabilities = capabilities,
    }))
    vim.lsp.enable(server)
end
