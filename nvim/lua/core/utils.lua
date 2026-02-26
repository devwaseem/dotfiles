local M = {}

local map_generator = function(mode)
    local map = function(keys, expr, desc, opts)
        if type(desc) == "table" and opts == nil then
            opts = desc
            desc = nil
        end

        local base_opts = {
            desc = desc,
            noremap = true,
            silent = false,
        }

        if opts then
            base_opts = vim.tbl_extend("force", base_opts, opts)
        end

        if type(keys) == "table" then
            for _, value in ipairs(keys) do
                vim.keymap.set(mode, value, expr, base_opts)
            end
        else
            vim.keymap.set(mode, keys, expr, base_opts)
        end
    end
    return map
end

M.nmap = map_generator('n')
M.vmap = map_generator('v')
M.xmap = map_generator('x')
M.tmap = map_generator('t')

return M
