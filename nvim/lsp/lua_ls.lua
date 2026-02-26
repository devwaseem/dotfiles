return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { '.luarc.json' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
