return {
    'barrett-ruth/telescope-http.nvim',
    keys = {
        {"<leader>fh", function() require('telescope').extensions.http.list() end, desc="Find HTTP Status Code"}
    },

    config = function()
        require('telescope').load_extension 'http'
        local my_theme = require('overrides.telescope').get_ivy_theme()
        require('telescope').setup({
            extensions = {
                http = {
                    -- open_url = 'xdg-open %s' -- UNIX
                    open_url = 'open %s' -- OSX
                    -- open_url = 'start %s' -- Windows
                }
            }
        })
    end,
}
