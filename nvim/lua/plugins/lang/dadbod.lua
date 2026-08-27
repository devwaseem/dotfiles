return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod",                     lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.keymap.set(
            "n",
            "<leader>ue",
            "<cmd>DBUIToggle<cr>",
            { silent = true, noremap = true, desc = "Toggle DBUI" }
        )
    end,
}
