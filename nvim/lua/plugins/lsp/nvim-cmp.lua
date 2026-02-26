return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    enabled = false,
    dependencies = {
        'L3MON4D3/LuaSnip',
        "tailwind-tools",
        'onsails/lspkind.nvim',
        'rafamadriz/friendly-snippets',
        'saadparwaiz1/cmp_luasnip',
        "hrsh7th/cmp-calc",
        'chrisgrieser/cmp-nerdfont',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'lukas-reineke/cmp-under-comparator',
    },

    config = function()
        local cmp = require('cmp')
        local lspkind = require('lspkind')

        -- loads vscode style snippets from installed plugins
        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = { "menu", "menuone", "preview", "noselect" }

        local source_mapping = {
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[Lua]',
            cmp_ai = '[AI]',
            path = '[Path]',
            Supermaven = "",
        }

        cmp.setup({

            experimental = {
                ghost_text = true,
                native_menu = false,
            },

            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },

            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },

            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    require "cmp-under-comparator".under,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },

            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-.>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),

            sources = cmp.config.sources({
                -- { name = "supermaven", priority = 1000 },
                { name = 'nvim_lsp', priority = 900 },
                { name = 'luasnip',  priority = 750 }, -- For luasnip users.
            }, {
                { name = 'buffer',          priority = 500 },
                { name = 'path',            priority = 400 },
                { name = 'emoji',           priority = 300 },
                { name = 'render-markdown', priority = 200 },
                -- { name = "neorg" },
                { name = 'calc',            priority = 200 },
                { name = 'nerdfont',        priority = 100 },
            }),

            formatting = {
                -- format = lspkind.cmp_format({
                --     mode = 'symbol_text',  -- show only symbol annotations
                --     maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                --     ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                --
                --     -- The function below will be called before any actual modifications from lspkind
                --     -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                --     before = require("tailwindcss-colorizer-cmp").formatter
                -- })
                format = function(entry, vim_item)
                    -- if you have lspkind installed, you can use it like
                    -- in the following line:
                    vim_item = require("tailwind-tools.cmp").lspkind_format(entry, vim_item)
                    vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol' })
                    vim_item.menu = source_mapping[entry.source.name]
                    local maxwidth = 80
                    vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
                    vim_item = require("nvim-highlight-colors").format(entry, vim_item)
                    return vim_item
                end,
            }
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
                { name = 'buffer' },
            })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })
    end
}
