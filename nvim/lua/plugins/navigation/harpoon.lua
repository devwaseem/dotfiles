local function toggle_telescope(harpoon_files)
    local telescope_config = require("telescope.config").values
    local file_paths = {}

    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = telescope_config.file_previewer({}),
        sorter = telescope_config.generic_sorter({}),
    }):find()
end

local function harpoon_list()
    return require("harpoon"):list()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>hh", function() toggle_telescope(harpoon_list()) end, desc = "Harpoon: List files" },
        { "<leader>hm", function() require("harpoon").ui:toggle_quick_menu(harpoon_list()) end, desc = "Harpoon: Toggle quick menu" },
        { "<leader>mm", function() harpoon_list():add() end, desc = "Harpoon: Add file" },
        { "<leader>1", function() harpoon_list():select(1) end, desc = "Harpoon: Go to file 1" },
        { "<leader>2", function() harpoon_list():select(2) end, desc = "Harpoon: Go to file 2" },
        { "<leader>3", function() harpoon_list():select(3) end, desc = "Harpoon: Go to file 3" },
        { "<leader>4", function() harpoon_list():select(4) end, desc = "Harpoon: Go to file 4" },
        { "<leader>5", function() harpoon_list():select(5) end, desc = "Harpoon: Go to file 5" },
        { "<leader>6", function() harpoon_list():select(6) end, desc = "Harpoon: Go to file 6" },
        { "<S-h>", function() harpoon_list():prev() end, desc = "Harpoon: Previous file" },
        { "<S-l>", function() harpoon_list():next() end, desc = "Harpoon: Next file" },
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
                key = function()
                    return vim.loop.cwd()
                end,
            },
        })

        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr })
            end,
        })

        harpoon:extend(require("harpoon.extensions").builtins.highlight_current_file())
    end,
}
