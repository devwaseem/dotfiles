return {
    "WilliamHsieh/overlook.nvim",
    opts = {
        border = "none",
    },
    keys = {
        { "<leader>pp", function() require("overlook.api").peek_definition() end,         desc = "Overlook: Peek definition" },
        { "<leader>pl", function() require("overlook.api").peek_cursor() end,             desc = "Overlook: Peek cursor" },
        { "<leader>pu", function() require("overlook.api").restore_popup() end,           desc = "Overlook: Restore last popup" },
        { "<leader>pU", function() require("overlook.api").restore_all_popups() end,      desc = "Overlook: Restore all popups" },
        { "<leader>pc", function() require("overlook.api").close_all() end,               desc = "Overlook: Close all popups" },
        { "<leader>pf", function() require("overlook.api").switch_focus() end,            desc = "Overlook: Switch focus" },
        { "<leader>ps", function() require("overlook.api").open_in_split() end,           desc = "Overlook: Open popup in split" },
        { "<leader>pv", function() require("overlook.api").open_in_vsplit() end,          desc = "Overlook: Open popup in vsplit" },
        { "<leader>pt", function() require("overlook.api").open_in_tab() end,             desc = "Overlook: Open popup in tab" },
        { "<leader>po", function() require("overlook.api").open_in_original_window() end, desc = "Overlook: Open popup in current window" }
    },
}
