return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
                key = function()
                    return vim.loop.cwd()
                end,
            }
        })


        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

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

        local harpoon_extensions = require("harpoon.extensions")
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        vim.keymap.set(
            "n",
            "<leader>hh",
            function() toggle_telescope(harpoon:list()) end,
            { desc = "Harpoon: List files" }
        )
        vim.keymap.set(
            "n",
            "<leader>hm",
            function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Harpoon: Toggle quick menu" }
        )
        vim.keymap.set(
            "n",
            "<leader>mm",
            function() harpoon:list():add() end,
            { desc = "Harpoon: Add file" }
        )
        vim.keymap.set(
            "n",
            "<leader>1",
            function() harpoon:list():select(1) end
        )
        vim.keymap.set(
            "n",
            "<leader>2",
            function() harpoon:list():select(2) end
        )
        vim.keymap.set(
            "n",
            "<leader>3",
            function() harpoon:list():select(3) end
        )
        vim.keymap.set(
            "n",
            "<leader>4",
            function() harpoon:list():select(4) end
        )

        vim.keymap.set(
            "n",
            "<leader>5",
            function() harpoon:list():select(5) end
        )
        vim.keymap.set(
            "n",
            "<leader>6",
            function() harpoon:list():select(6) end
        )

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<S-h>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<S-l>", function() harpoon:list():next() end)
    end,

}
