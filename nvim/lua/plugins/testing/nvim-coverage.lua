return {
    "andythigpen/nvim-coverage",
    version = "*",
    event = "VeryLazy",
    cmd = {
        "Coverage",
        "CoverageToggle",
        "CoverageShow",
        "CoverageHide",
        "CoverageSummary",
    },
    config = function()
        local coverage = require("coverage")
        coverage.setup({
            auto_reload = true,
        })
    end,
}
