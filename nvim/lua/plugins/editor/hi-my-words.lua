return {
    "dvoytik/hi-my-words.nvim",
    cmd = {
        "HiMyWordsToggle",
        "HiMyWordsClear",
    },
    keys = {
        { "<leader>uh", "<cmd>HiMyWordsToggle<cr>", desc = "Highlight word (toggle)" },
        { "<leader>uH", "<cmd>HiMyWordsClear<cr>",  desc = "Clear highlights" },
    },
    config = true,
}
