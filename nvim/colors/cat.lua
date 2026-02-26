-- The code for the colorscheme starts here
local colors = {
    bg = "#000000", -- Your main background color
    fg = "#cad3f5", -- Your main foreground/text color
    cursor = "#f4dbd6",
    red = "#ed8796",
    green = "#a6da95",
    yellow = "#eed49f",
    blue = "#8aadf4",
    magenta = "#f5bde6",
    cyan = "#8bd5ca",
    white = "#b8c0e0",
    black = "#494d64",
    comment = "#939ab7",
    link_text = "#b7bdf8",
    link_uri = "#8aadf4",
    keyword = "#c6a0f6",
    function_name = "#8aadf4",
    string = "#a6da95",
    number = "#f5a97f",
    type = "#eed49f",
    variable = "#cad3f5",
    operator = "#91d7e3",
    punctuation = "#939ab7",
    line_number = "#ffffff",
    active_line_number = "#f4dbd6",
    active_line_bg = "#f4dbd6",
}

-- Set the background and foreground colors
vim.o.background = "dark"
vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })

-- Set up common highlight groups
vim.api.nvim_set_hl(0, "Cursor", { fg = colors.cursor, bg = colors.cursor, reverse = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.line_number, bg = colors.bg })
-- vim.api.nvim_set_hl(0, "Comment", { fg = colors.comment, style = "italic" })
vim.api.nvim_set_hl(0, "String", { fg = colors.string })
vim.api.nvim_set_hl(0, "Number", { fg = colors.number })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "Statement", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "Function", { fg = colors.function_name })
vim.api.nvim_set_hl(0, "Type", { fg = colors.type })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.variable })
vim.api.nvim_set_hl(0, "Operator", { fg = colors.operator })
vim.api.nvim_set_hl(0, "Punctuation", { fg = colors.punctuation })

-- Set up editor-specific highlights
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.active_line_bg })
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.active_line_number, style = "bold" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#363a4f" }) -- from your "element.selected"
vim.api.nvim_set_hl(0, "Search", { bg = "#8bd5ca" }) -- from your "search.match_background"

-- Git/Diff highlights
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#a6da95", fg = colors.green })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#eed49f", fg = colors.yellow })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#ed8796", fg = colors.red })

-- Status and UI elements
vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.comment, bg = "#181926" }) -- title_bar.inactive_background
vim.api.nvim_set_hl(0, "TabLine", { bg = colors.bg })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.bg })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.fg, bg = "#f4dbd6" }) -- tab.active_background

-- Common syntax highlighting (map your JSON to Neovim names)
vim.api.nvim_set_hl(0, "Conditional", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "Exception", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "Repeat", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "Typedef", { fg = colors.type })
vim.api.nvim_set_hl(0, "Tag", { fg = colors.blue })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.number })
-- vim.api.nvim_set_hl(0, "Todo", { fg = colors.fg, bg = colors.yellow, style = "bold" })

-- Example of mapping syntax groups from your JSON to Neovim
vim.api.nvim_set_hl(0, "htmlTagName", { fg = colors.blue })
-- vim.api.nvim_set_hl(0, "htmlArg", { fg = colors.yellow, style = "italic" })
