local palette_path = vim.fn.stdpath("config") .. "/lua/core/palette.json"
local contents = table.concat(vim.fn.readfile(palette_path), "\n")
local ok, palette = pcall(vim.json.decode, contents)

if not ok then
    error("Unable to load the shared color palette: " .. palette)
end

return palette
