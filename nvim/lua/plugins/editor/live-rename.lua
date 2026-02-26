return {
    "saecki/live-rename.nvim",
    enabled = false,
    config = function()
        require("live-rename").setup({
            -- Send a `textDocument/prepareRename` request to the server to
            -- determine the word to be renamed, can be slow on some servers.
            -- Otherwise fallback to using `<cword>`.
            prepare_rename = true,
            request_timeout = 1500,
            keys = {
                submit = {
                    { "n", "<cr>" },
                    { "v", "<cr>" },
                    { "i", "<cr>" },
                },
                cancel = {
                    { "n", "<esc>" },
                    { "n", "q" },
                },
            },
            hl = {
                current = "CurSearch",
                others = "Search",
            },
        })
    end
}
