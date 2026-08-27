return {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    ft = { "astro", "css", "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    build = ":UpdateRemotePlugins",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
    opts = {}
}
