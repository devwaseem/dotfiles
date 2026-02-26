return {
    "eandrju/cellular-automaton.nvim",
    enabled = true,
    cmd = { "CellularAutomaton" },
    keys = {
        { "<leader>Ux",  desc = "CellularAutomaton" },
        { "<leader>Uxr", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
        { "<leader>Uxg", "<cmd>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
        { "<leader>Uxs", "<cmd>CellularAutomaton scramble<CR>",     desc = "Scramble" },
    }
}
