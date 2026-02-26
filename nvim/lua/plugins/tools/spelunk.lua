return {
    'EvWilson/spelunk.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',           -- For window drawing utilities
        'nvim-telescope/telescope.nvim',   -- Optional: for fuzzy search capabilities
        'nvim-treesitter/nvim-treesitter', -- Optional: for showing grammar context
    },
    opts = {
        base_mappings = {
            -- Toggle the UI open/closed
            toggle = '<leader>mt',
            -- Add a bookmark to the current stack
            add = 'm,',
            -- Move to the next bookmark in the stack
            next_bookmark = 'm]',
            -- Move to the previous bookmark in the stack
            prev_bookmark = 'm[',
            -- Fuzzy-find all bookmarks
            search_bookmarks = '<leader>mf',
            -- Fuzzy-find bookmarks in current stack
            search_current_bookmarks = '<leader>mc',
            -- Fuzzy find all stacks
            search_stacks = '<leader>ms',
        },
        window_mappings = {
            -- Move the UI cursor down
            cursor_down = '<Down>',
            -- Move the UI cursor up
            cursor_up = '<Up>',
            -- Move the current bookmark down in the stack
            bookmark_down = '<C-j>',
            -- Move the current bookmark up in the stack
            bookmark_up = '<C-k>',
            -- Jump to the selected bookmark
            goto_bookmark = '<CR>',
            -- Jump to the selected bookmark in a new vertical split
            goto_bookmark_hsplit = 'x',
            -- Jump to the selected bookmark in a new horizontal split
            goto_bookmark_vsplit = 'v',
            -- Delete the selected bookmark
            delete_bookmark = 'd',
            -- Navigate to the next stack
            next_stack = '<Tab>',
            -- Navigate to the previous stack
            previous_stack = '<S-Tab>',
            -- Create a new stack
            new_stack = 'n',
            -- Delete the current stack
            delete_stack = 'D',
            -- Rename the current stack
            edit_stack = 'E',
            -- Close the UI
            close = 'q',
            -- Open the help menu
            help = 'h',
        },
        -- Flag to enable directory-scoped bookmark persistence
        enable_persist = false,
        -- Prefix for the Lualine integration
        -- (Change this if your terminal emulator lacks emoji support)
        statusline_prefix = '',
        -- Set UI orientation
        -- Type: 'vertical' | 'horizontal' | LayoutProvider
        -- Advanced customization: you may set your own layout provider for fine-grained control over layout
        -- See `layout.lua` for guidance on setting this up
        orientation = 'vertical',
        -- Enable to show mark index in status column
        enable_status_col_display = true,
        -- The character rendered before the currently selected bookmark in the UI
        cursor_character = '>',
        -- Set whether or not to persist bookmarks per git branch
        persist_by_git_branch = true,
    },
    config = function(_, opts)
        require('spelunk').setup(opts)
    end
}
