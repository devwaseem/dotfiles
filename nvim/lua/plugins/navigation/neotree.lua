local icons = require("core.icons")
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        { "<leader>o",  "<cmd>Neotree toggle=true source=filesystem reveal=true position=bottom<CR>", desc = "Open Filesystem Explorer as float" },
        { "<leader>el", "<cmd>Neotree toggle=true source=filesystem reveal=true position=left<CR>",   desc = "Open Filesystem Explorer to the left" },
        { "<leader>er", "<cmd>Neotree toggle=true source=filesystem reveal=true position=right<CR>",  desc = "Open Filesystem Explorer to the right" },
        { "<leader>et", "<cmd>Neotree toggle=true source=filesystem reveal=true position=top<CR>",    desc = "Open Filesystem Explorer to the top" },
        { "<leader>eb", "<cmd>Neotree toggle=true source=buffers position=float<CR>",                 desc = "Open Buffer explorer as float" },
    },
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require('neo-tree').setup({
            close_if_last_window = true,
            default_component_configs = {
                indent = {
                    with_markers = true,
                    indent_marker = icons.tree.vertical,
                    last_indent_marker = icons.tree.nodelast,
                    indent_size = 2,
                },
                icon = {
                    folder_closed = icons.folder.closed,
                    folder_open = icons.folder.open,
                    folder_empty = icons.folder.empty,
                    folder_empty_open = icons.folder.empty_open,
                    default = icons.files.default,
                },
                modified = {
                    symbol = icons.modified,
                },
                name = {
                    highlight_opened_files = true,
                },
                git_status = {
                    symbols = icons.gitsigns,
                    align = "left",
                },
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                use_libuv_file_watcher = true,
                window = {
                    mappings = {
                        ["o"] = "system_open",
                        ["~"] = "toggle_hidden",
                    },
                },
                commands = {
                    system_open = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        -- macOs: open file in default application in the background.
                        vim.fn.jobstart({ "open", "-g", path }, { detach = true })
                    end,
                },
            },
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.statuscolumn = ''
                        vim.opt_local.foldcolumn = "0"
                    end
                },

                {
                    event = "file_opened",
                    handler = function(file_path)
                        require("neo-tree.command").execute({ action = "close" })
                    end
                },
            },
        })
    end,
}
