return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
        require('gitsigns').setup({
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']g', function()
                    if vim.wo.diff then return ']g' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                map('n', '[g', function()
                    if vim.wo.diff then return '[g' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                if pcall(require, "which-key") then
                    local wk = require('which-key')
                    wk.add {
                        { "<leader>gt", name = "Toggle" }
                    }
                end

                -- Actions
                map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
                map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
                map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Stage selected hunk" })
                map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Reset selected hunk" })
                map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage Buffer" })
                map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
                map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset Buffer" })
                map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview hunk" })
                map('n', '<leader>gb', function() gs.blame_line { full = true } end, { desc = "Blame Line" })
                map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
                map('n', '<leader>gd', gs.diffthis, { desc = "Diff This" })
                map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "Diff This ~" })
                map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        })

        -- scrollbar
        -- if pcall(require, 'scrollbar') then
        --     require("scrollbar.handlers.gitsigns").setup()
        -- end
    end
}
