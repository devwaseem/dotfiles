return {
    'David-Kunz/markid',
    event = { "BufReadPost *.c, *.py, *.cpp, *.js, *.ts" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        require('markid').setup()
        require 'nvim-treesitter.configs'.setup {
            markid = { enable = true }
        }
    end
}
