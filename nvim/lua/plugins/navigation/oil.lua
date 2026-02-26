return {
    'stevearc/oil.nvim',
    keys = {
        { "_", "<CMD>Oil --float<CR>", desc = "Open parent directory" }
    },
    opts = {
        delete_to_trash = true,
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
