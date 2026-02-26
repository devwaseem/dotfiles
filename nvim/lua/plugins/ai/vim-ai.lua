return {
    "madox2/vim-ai",
    dependencies = {
        "madox2/vim-ai-provider-google"
    },
    cmd = {
        "AI",
        "AIEdit",
        "AIChat",
        "AIStopChat",
        "AIImage",
        "AIRedo",
        "AIUtilRolesOpen",
        "AIUtilDebugOn",
        "AIUtilDebugOff",
    },
    keys = {
        { "<leader>A",     group = "AI" },
        { "<leader>A<CR>", "<cmd>AI<CR>",              { mode = "v", desc = "AI: Complete" } },
        { "<leader>Ae",    "<cmd>AIEdit<CR>",          { mode = { "n", "v" }, desc = "AI: Edit" } },
        { "<leader>Ac",    "<cmd>AIChat<CR>",          { mode = { "n", "v" }, desc = "AI: Chat" } },
        { "<leader>As",    "<cmd>AIStopChat<CR>",      { mode = "n", desc = "AI: Stop Chat" } },
        { "<leader>Ai",    "<cmd>AIImage<CR>",         { mode = "n", desc = "AI: Generate Image" } },
        { "<leader>Ar",    "<cmd>AIRedo<CR>",          { mode = "n", desc = "AI: Redo last action" } },
        { "<leader>Ao",    "<cmd>AIUtilRolesOpen<CR>", { mode = "n", desc = "AI: Open Roles" } },
        { "<leader>Ad",    "<cmd>AIUtilDebugOn<CR>",   { mode = "n", desc = "AI: Debug On" } },
        { "<leader>AD",    "<cmd>AIUtilDebugOff<CR>",  { mode = "n", desc = "AI: Debug Off" } },
    },
    config = function()
        -- vim.g.vim_ai_token_file_path = '~/.tokens/gemini'
        vim.g.vim_ai_roles_config_file = '~/.config/nvim/config/vim-ai.role'
        require("vim-ai").setup()
    end
}
