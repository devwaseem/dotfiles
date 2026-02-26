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
    opts = {
        -- cursor_color = "#ff8800",
        -- stiffness = 0.3,
        -- trailing_stiffness = 0.1,
        -- damping = 0.5,
        -- trailing_exponent = 5,
        -- never_draw_over_target = true,
        -- hide_target_hack = true,
        -- gamma = 1,
    },
    config = function(_, opts)
        local smear_cursor = require("smear_cursor")
        smear_cursor.setup(opts)
        -- smear_cursor.enabled = vim.g.smear_cursor_enabled
        vim.keymap.set("n", "<leader>Uc", toggle, { desc = "Toggle smear cursor" })
    end
}
