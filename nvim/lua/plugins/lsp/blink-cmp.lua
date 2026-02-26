return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        'rafamadriz/friendly-snippets',
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        {
            "mikavilpas/blink-ripgrep.nvim",
            version = "*", -- use the latest stable version
        }
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        snippets = {
            preset = 'luasnip'
        },
        signature = {
            enabled = true,
            window = {
                scrollbar = false,
                winblend = 10,
            }
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
            accept = {
                -- experimental auto-brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                draw = {
                    gap = 2,
                    columns = {
                        { "kind_icon" },
                        { "label",    "source_name", gap = 1 },
                    },
                    treesitter = {
                        "lsp"
                    },
                    components = {
                        kind_icon = {
                            -- text = function(ctx)
                            --     print(ctx.kind)
                            --     if ctx.kind == "Git" then
                            --         return ""
                            --     end
                            --     local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                            --     return kind_icon
                            -- end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        }
                    }
                }
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = {
                'lsp',
                'path',
                "django",
                'snippets',
                'buffer',
            },
            per_filetype = {
                sql = { 'lsp', 'snippets', 'dadbod', 'buffer' },
            },
            providers = {
                path = {
                    opts = {
                        get_cwd = function(_)
                            return vim.fn.getcwd()
                        end,
                    },
                },
                dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                django = {
                    name = "Django",
                    module = "django.completions.blink",
                    async = true,
                },
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "grep",
                    score_offset = -100,
                    ---@module "blink-ripgrep"
                    ---@type blink-ripgrep.Options
                    opts = {
                        prefix_min_len = 3,
                        project_root_marker = { ".git", "Makefile", "package.json", "pyproject.toml", "cargo.toml" },
                        toggles = {
                            on_off = "<leader>lg",

                            -- The keymap to toggle debug mode on/off. Example: "<leader>td" ("toggle debug")
                            debug = nil,
                        },
                        backend = {
                            use = "gitgrep-or-ripgrep",
                            customize_icon_highlight = true,
                        },
                        transform_items = function(_, items)
                            for _, item in ipairs(items) do
                                item.labelDetails = {
                                    description = "(rg)",
                                }
                            end
                            return items
                        end,
                    },
                },
            },
        },

        cmdline = {
            enabled = true,
            keymap = { preset = "cmdline" },
            completion = {
                list = { selection = { preselect = false } },
                menu = {
                    auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ":"
                    end,
                },
                ghost_text = { enabled = true },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = {
            sorts = {
                'exact',
                'score',
                'sort_text',
            },
            implementation = "prefer_rust_with_warning"
        },
        keymap = {
            preset = 'enter',
            ["<C-g>"] = {
                function()
                    require("blink-cmp").show({ providers = { "ripgrep" } })
                end,
            },
            ['<C-j>'] = { 'scroll_documentation_down' },
            ['<C-k>'] = { 'scroll_documentation_up' },
            ['<C-x>'] = { 'show' },
        },
    },
    opts_extend = { "sources.default" },
}
