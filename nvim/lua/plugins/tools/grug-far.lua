return {
    'MagicDuck/grug-far.nvim',
    keys = {
        { '<leader>sr', ':GrugFar<cr>', desc = 'Search and Replace with GrugFar' },
    },
    config = function()
        require('grug-far').setup({
        });
    end
}
