local utils = require('core.utils')
local nmap = utils.nmap
local vmap = utils.vmap

--
nmap('<leader>w', "<cmd>w<CR>", "Save File")

-- Quickfix
nmap('<leader>QQ', "<cmd>copen<CR>", "Open Quickfix")
nmap('<leader>Qc', "<cmd>cclose<CR>", "Close Quickfix")
nmap('<C-n>', "<cmd>cnext<CR>", "Go to Next Quickfix")
nmap('<C-p>', "<cmd>cprevious<CR>", "Go to Prev Quickfix")

-- Diagnostics
nmap(']d', vim.diagnostic.goto_next, "Go to Next Diagnostic")
nmap('[d', vim.diagnostic.goto_prev, "Go to Prev Diagnostic")
nmap('<leader>ud', "<cmd>DiagnosticFloatToggle<CR>", "Toggle Diagnostic Float")
nmap('<leader>uD', "<cmd>DiagnosticFloatToggle!<CR>", "Toggle Diagnostic Float (Buffer)")

-- Buffers
nmap({ ']b', "<leader>bn" }, "<cmd>bnext<CR>", "Go to Next Buffer")
nmap({ '[b', "<leader>bp" }, "<cmd>bprevious<CR>", "Go to Previous Buffer")
nmap({ '<leader>c', "<leader>bc" }, "<cmd>bdelete<CR>", "Close Current Buffer")

-- Move windows
nmap('<M-Right>', "<C-w>l", "Move to right window")
nmap('<M-Left>', "<C-w>h", "Move to left window")
nmap('<M-Up>', "<C-w>k", "Move to top window")
nmap('<M-Down>', "<C-w>j", "Move to bottom window")


-- Move lines
-- vim.keymap.set('n', 'M', '<cmd>m .+1<CR>gv=gv', { silent = true, desc = 'Move line down' })
-- vim.keymap.set('n', 'N', '<cmd>m .-2<CR>gv=gv', { silent = true, desc = 'Move line up' })
-- vim.keymap.set('v', 'M', "<cmd>m '>+1<CR>gv=gv", { silent = true, desc = 'Move selection down' })
-- vim.keymap.set('v', 'N', "<cmd>m '<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })

-- Center screen when scrolling
nmap("<C-d>", "<C-d>zz", "Move Down")
nmap("<C-u>", "<C-u>zz", "Move Up")

--Select All Text
vim.keymap.set('n', 'vig', function()
    vim.cmd 'normal! gg0vG$'
end, { desc = 'Select All Text' })
