return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "rmd" },
    keys = {
        { "<leader>um", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle Markdown rendering" },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.icons",
    },
    opts = {},
}
