return {
    "nkakouros-original/numbers.nvim",
    event = "BufReadPost",
    enabled = false,
    config = function()
        require('numbers').setup()
    end
}
