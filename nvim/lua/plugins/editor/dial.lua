local function dial(increment, g)
    local mode = vim.fn.mode(true)
    -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
    local is_visual = mode == "v" or mode == "V" or mode == "\22"
    local action = increment and "increment" or "decrement"
    local action_mode = (g and 'g' or '') .. (is_visual and "visual" or "normal")
    require("dial.map").manipulate(action, action_mode)
end

return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-e>",  function() dial(true, false) end,  desc = "Increment", mode = { "n", "v" } },
        { "<C-x>",  function() dial(false, false) end, desc = "Decrement", mode = { "n", "v" } },
        { "g<C-e>", function() dial(true, true) end,   desc = "Increment", mode = { "n", "x" } },
        { "g<C-x>", function() dial(false, true) end,  desc = "Decrement", mode = { "n", "x" } },
    },
    opts = function()
        local augend = require("dial.augend")

        local logical_alias = augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
        })

        local ordinal_numbers = augend.constant.new({
            -- elements through which we cycle. When we increment, we go down
            -- On decrement we go up
            elements = {
                "first",
                "second",
                "third",
                "fourth",
                "fifth",
                "sixth",
                "seventh",
                "eighth",
                "ninth",
                "tenth",
            },
            -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
            word = false,
            -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
            -- Otherwise nothing will happen when there are no further values
            cyclic = true,
        })

        local weekdays = augend.constant.new({
            elements = {
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday",
            },
            word = true,
            cyclic = true,
        })

        local months = augend.constant.new({
            elements = {
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
            },
            word = true,
            cyclic = true,
        })

        local capitalized_boolean = augend.constant.new({
            elements = {
                "True",
                "False",
            },
            word = true,
            cyclic = true,
        })

        return {
            dials_by_ft = {
                python = "python",
                css = "css",
                vue = "vue",
                javascript = "typescript",
                typescript = "typescript",
                typescriptreact = "typescript",
                javascriptreact = "typescript",
                json = "json",
                html = "html",
                lua = "lua",
                markdown = "markdown",
                sass = "css",
                scss = "css",
            },
            groups = {
                default = {
                    augend.constant.alias.bool, -- boolean value (true <-> false)
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%d/%m/%Y"],
                    augend.hexcolor.new({ case = "lower" }),
                    augend.hexcolor.new({ case = "upper" }),
                    augend.integer.alias.decimal,     -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
                    augend.integer.alias.hex,         -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                    augend.semver.alias.semver,       -- versioning (v1.1.2)
                    capitalized_boolean,
                    logical_alias,
                    months,
                    ordinal_numbers,
                    weekdays,
                },
                vue = {
                    augend.constant.new({ elements = { "let", "const" } }),
                },
                typescript = {
                    augend.constant.new({ elements = { "let", "const" } }),
                },
                css = {},
                markdown = {
                    augend.constant.new({
                        elements = { "[ ]", "[x]" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.misc.alias.markdown_header,
                },
                json = {},
                lua = {
                    augend.constant.new({
                        elements = { "and", "or" },
                        word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                        cyclic = true, -- "or" is incremented into "and".
                    }),
                },
                python = {
                    augend.constant.new({
                        elements = { "and", "or" },
                    }),
                },
            },
        }
    end,
    config = function(_, opts)
        for name, group in pairs(opts.groups) do
            if name ~= "default" then
                vim.list_extend(group, opts.groups.default)
            end
        end

        require("dial.config").augends:register_group(opts.groups)
        require("dial.config").augends:on_filetype(opts.groups)
    end,
}
