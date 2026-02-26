return {
    "ruicsh/tailwind-hover.nvim",
    keys = {
        { "<leader>lt",  desc = "Tailwind" },
        { "<leader>ltk", "<cmd>TailwindHover<cr>", desc = "Tailwind: Hover" },
    },
    opts = {},
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
}
