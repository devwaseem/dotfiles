local is_inside_work_tree = {}
local utils = require("telescope.utils")
local builtin = require('telescope.builtin')

local function open_project_files()
    local ivy_theme = require('telescope.themes').get_ivy()

    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        builtin.git_files(
            vim.tbl_deep_extend("force", ivy_theme, {
                show_untracked = true
            })
        )
    else
        builtin.find_files(ivy_theme)
    end
end

local function grep_cword()
    builtin.grep_string({
        search = vim.fn.expand("<cword>"),
    })
end

local function grep_visual_selection()
    local mode = vim.fn.visualmode()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2] - 1
    local start_col = start_pos[3] - 1
    local end_row = end_pos[2] - 1
    local end_col = end_pos[3]

    if start_row > end_row or (start_row == end_row and start_col > end_col) then
        start_row, end_row = end_row, start_row
        start_col, end_col = end_col - 1, start_col + 1
    end

    if mode == "V" then
        start_col = 0
        local end_line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1] or ""
        end_col = #end_line
    end

    local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    local selection = table.concat(lines, "\n")

    if selection == "" then
        return
    end

    builtin.grep_string({
        search = selection,
    })
end

return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
        -- Find
        { "<leader>ff",       function() open_project_files() end,                                     desc = "Find Project Files" },
        { "<leader><leader>", function() open_project_files() end,                                     desc = "Find Project Files" },
        { "<leader>fF",       "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",  desc = "Find All Files" },
        { "<leader>fb",       "<cmd>Telescope buffers sort_mru=true sort_lastused=true theme=ivy<cr>", desc = "Find Buffers" },
        { "<leader>fo",       function() require('telescope.builtin').oldfiles() end,                  desc = "Find Recent Opened files" },
        { "<leader>fc",       function() require('telescope.builtin').commands() end,                  desc = "Find Commands" },
        { "<leader>fm",       function() require('telescope.builtin').marks() end,                     desc = "Find Vim Marks" },
        { "<leader>fk",       function() require('telescope.builtin').keymaps() end,                   desc = "Find Keymaps" },
        { "<leader>f=",       "<cmd>Telescope resume<cr>",                                             desc = "Resume Last Find" },
        { "<leader>f/",       function() require('telescope.builtin').live_grep() end,                 desc = "Search in CWD" },
        { "<leader>fw",       grep_cword,                                                                desc = "Search Word Under Cursor" },
        { "<leader>fw",       grep_visual_selection,                                                     mode = "x", desc = "Search Selection" },

        -- Git
        { "<leader>gC",       function() require('telescope.builtin').git_commits() end,               desc = "Git Commits" },
        { "<leader>gc",       function() require('telescope.builtin').git_bcommits() end,              desc = "Git Commits (Current buffer)" },
        { "<leader>gb",       function() require('telescope.builtin').git_branches() end,              desc = "Git Branches" },


    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local my_theme = require('overrides.telescope').get_ivy_theme()

        telescope.setup {
            defaults = vim.tbl_deep_extend("force", my_theme, {
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
                path_display = { "truncate", },
                vimgrep_arguments = {
                    'rg',
                    '--hidden',
                    '--glob',
                    '!**/.git/*',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                }
            }),
            pickers = {
                colorscheme = {
                    enable_preview = true
                },
                find_files = {
                    cwd = utils.buffer_dir(),
                    find_command = {
                        'fd',
                        '--type',
                        'f',
                        '--color=never',
                        '--hidden',
                        '--follow',
                        '-E',
                        '.git',
                        '-E',
                        '.venv',
                        '-E',
                        'node_modules'
                    },
                },
                oldfiles = {
                    cwd_only = true,
                    cwd = utils.buffer_dir(),
                }
            },
        }
        pcall(telescope.load_extension, 'fzf')
    end,
}
