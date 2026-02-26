local options = {
    autoindent = true,
    autoread = true,
    autowrite = true,
    background = "dark",            -- colorschemes that can be light or dark will be made dark
    backspace = "indent,eol,start", -- allow backspace on indent, end of line or insert mode start position
    backup = false,
    breakindent = true,
    clipboard = "unnamedplus",
    cmdheight = 0,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    cursorcolumn = false,
    cursorline = false,
    equalalways = false,
    errorbells = false,
    expandtab = true,
    fileencoding = "utf-8",
    foldcolumn = "1",
    foldenable = true,
    foldlevel = 99,
    foldlevelstart = 99,
    -- foldmethod = "manual",
    foldnestmax = 10,
    guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25,a:blinkwait700-blinkoff400-blinkon250',
    hidden = true,
    hlsearch = true,
    ignorecase = true,
    incsearch = true,
    inccommand = "split",
    infercase = true,
    linebreak = true,
    list = true,
    mouse = "a",
    nrformats = "alpha",
    number = true,
    pumheight = 10,
    relativenumber = true,
    ruler = false,
    scrolloff = 8,
    shiftwidth = 4,
    showmode = true,
    showtabline = 1, -- 0 = never, 1 = at end, 2 = always
    sidescrolloff = 8,
    signcolumn = "auto",
    smartcase = true,
    smartindent = true,
    softtabstop = 4,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    tabstop = 4,
    termguicolors = true,
    timeout = true,
    timeoutlen = 400,
    title = false,
    undofile = true,
    updatetime = 300,
    virtualedit = "block",
    winminwidth = 10,
    winwidth = 10,
    wrap = false,
    writebackup = false,
}
for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.listchars = {
    eol = '',
    tab = '> ',
}
vim.opt.fillchars = {
    fold = ' ', -- Character to fill the fold line (often a space, or a thin line like '─')
    -- foldopen = ' ', -- Character for an open fold in foldcolumn
    -- foldopen = '+',  -- Character for an open fold in foldcolumn
    foldopen = '▼', -- Character for an open fold in foldcolumn
    -- foldclose = ' ', -- Character for a closed fold in foldcolumn
    -- foldclose = '-', -- Character for a closed fold in foldcolumn
    foldclose = '▶', -- Character for a closed fold in foldcolumn
    foldsep = ' ', -- Character between foldlevel numbers (often a space)
    eob = '~', -- End of buffer fill character
}

vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
