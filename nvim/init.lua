vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        { import = "plugins" },
        { import = "plugins.ai" },
        { import = "plugins.dap" },
        { import = "plugins.editor" },
        { import = "plugins.git" },
        { import = "plugins.lang" },
        { import = "plugins.lsp" },
        { import = "plugins.navigation" },
        { import = "plugins.telescope" },
        { import = "plugins.testing" },
        { import = "plugins.tools" },
        { import = "plugins.ui" },
    },
    {
        concurrency = 10,
        checker = {
            enabled = true,
            notify = false,
        },
        change_detection = {
            notify = false,
        },
        performance = {
            rtp = {
                -- customize default disabled vim plugins
                disabled_plugins = {
                    "tohtml",
                    "gzip",
                    "matchit",
                    "zipPlugin",
                    "netrwPlugin",
                    "tarPlugin",
                },
            },
        },

    })


vim.cmd.colorscheme "material"
-- vim.cmd.colorscheme "teide-darker"
-- vim.cmd.colorscheme "koda"
require "core.highlights"

vim.opt.mouse = "a"

require("core.diagnostic").enable_diagnostic()

-- Alter Ego Setup
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = '*.tmd',
    callback = function()
        vim.bo.filetype = 'markdown'
        vim.bo.fileencoding = 'utf-8'
        vim.wo.wrap = true
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.cursorline = false
        vim.wo.colorcolumn = '0'
        vim.keymap.set("n", "<leader>=", function()
            require("custom.alter_ego.alter_ego").run_ego()
        end, { buffer = true })
    end
})
