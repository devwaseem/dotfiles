return {
    "ellisonleao/carbon-now.nvim",
    cmd = "CarbonNow",
    opts = {
        base_url = "https://carbon.now.sh/",
        open_cmd = 'open',
        theme = "duotone",
        drop_shadow = true,

        titlebar = function()
            local bufname = vim.api.nvim_buf_get_name(0)
            return bufname:match("^.+/(.+)$") or bufname
        end,

    },
    config = true

}
