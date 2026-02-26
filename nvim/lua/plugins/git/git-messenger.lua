return {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    keys = {
        { "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Last commit message" }

    },
    config = function()
        vim.g.git_messenger_no_default_mappings = true
        vim.g.git_messenger_always_into_popup = true
        vim.g.git_messenger_into_popup_after_show = false
        vim.g.git_messenger_floating_win_opts = { border = "none" }
    end
}
