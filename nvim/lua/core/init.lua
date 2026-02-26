require "core.lsp"
require "core.options"
require "core.autocmds"
require "core.keymaps"
require "core.cmds"


function R(name)
    require("plenary.reload").reload_module(name)
end
