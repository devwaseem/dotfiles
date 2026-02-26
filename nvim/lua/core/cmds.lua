vim.api.nvim_create_user_command("CopyRelativePath", function()
    local path = vim.fn.fnamemodify(vim.fn.expand('%'), ":.")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard')
end, {})

vim.g.diagnostic_float_enabled = true

vim.api.nvim_create_user_command("DiagnosticFloatToggle", function(args)
    if args.bang then
        vim.b.diagnostic_float_enabled = not vim.b.diagnostic_float_enabled
    else
        vim.g.diagnostic_float_enabled = not vim.g.diagnostic_float_enabled
    end
end, { bang = true, desc = "Toggle diagnostic float on CursorHold" })
