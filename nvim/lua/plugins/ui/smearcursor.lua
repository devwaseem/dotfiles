local function toggle()
    vim.g.smear_cursor_enabled = not vim.g.smear_cursor_enabled
    local cursor = require("smear_cursor")
    if vim.g.smear_cursor_enabled then
        vim.notify("Smear cursor enabled")
        cursor.enabled = true
    else
        vim.notify("Smear cursor disabled")
        cursor.enabled = false
    end
end

return {
    "sphamba/smear-cursor.nvim",
    keys = {
        { "<leader>Uc", toggle, desc = "Toggle smear cursor" },
    },
    opts = {},
    config = function(_, opts)
        local smear_cursor = require("smear_cursor")
        smear_cursor.setup(opts)
        smear_cursor.enabled = false
    end,
}
